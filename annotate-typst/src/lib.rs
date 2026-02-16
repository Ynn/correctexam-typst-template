use lopdf::{Dictionary, Document, Object, ObjectId};
use serde_json::Value;
use std::collections::BTreeMap;
use thiserror::Error;

const ATTACHMENT_NAME: &str = "correctexam-markers.json";

#[derive(Debug, Error)]
pub enum AnnotateError {
    #[error("PDF parse error: {0}")]
    Pdf(#[from] lopdf::Error),
    #[error("JSON parse error: {0}")]
    Json(#[from] serde_json::Error),
    #[error("I/O error: {0}")]
    Io(#[from] std::io::Error),
    #[error("missing attachment '{ATTACHMENT_NAME}'")]
    MissingMarkersAttachment,
    #[error("invalid PDF structure: {0}")]
    InvalidPdf(&'static str),
    #[error("marker JSON must be an array")]
    MarkerJsonNotArray,
}

#[derive(Debug, Clone)]
pub struct AnnotationSummary {
    pub marker_count: usize,
    pub annotation_count: usize,
}

pub fn parse_markers_json(markers_json: &str) -> Result<Vec<Value>, AnnotateError> {
    let parsed: Value = serde_json::from_str(markers_json)?;
    parsed
        .as_array()
        .cloned()
        .ok_or(AnnotateError::MarkerJsonNotArray)
}

pub fn extract_markers_from_pdf_bytes(pdf_bytes: &[u8]) -> Result<Vec<Value>, AnnotateError> {
    let doc = Document::load_mem(pdf_bytes)?;
    let content = extract_markers_attachment_content(&doc)?;
    let json = String::from_utf8_lossy(&content).to_string();
    parse_markers_json(&json)
}

pub fn annotate_pdf_bytes(pdf_bytes: &[u8]) -> Result<(Vec<u8>, AnnotationSummary), AnnotateError> {
    let mut doc = Document::load_mem(pdf_bytes)?;
    let content = extract_markers_attachment_content(&doc)?;
    let markers = parse_markers_json(&String::from_utf8_lossy(&content))?;
    let marker_map = build_marker_map(&markers);

    let info_id = ensure_info_dict(&mut doc);
    let dict = doc
        .get_object_mut(info_id)?
        .as_dict_mut()
        .map_err(|_| AnnotateError::InvalidPdf("invalid PDF info dictionary"))?;

    clear_existing_correctexam_markers(dict);

    for (key, payload) in &marker_map {
        let payload_text = serde_json::to_string(payload)?;
        dict.set(
            key.as_bytes().to_vec(),
            Object::string_literal(payload_text),
        );
    }

    let mut out = Vec::new();
    doc.save_to(&mut out)?;

    Ok((
        out,
        AnnotationSummary {
            marker_count: markers.len(),
            annotation_count: marker_map.len(),
        },
    ))
}

pub fn build_marker_map(markers: &[Value]) -> BTreeMap<String, Value> {
    let mut out = BTreeMap::new();

    for marker in markers {
        let Some(obj) = marker.as_object() else {
            continue;
        };

        let Some(key) = obj.get("key").and_then(Value::as_str) else {
            continue;
        };

        if key.is_empty() || out.contains_key(key) {
            continue;
        }

        let mut payload = serde_json::Map::new();
        for (field, value) in obj {
            if field != "key" {
                payload.insert(field.clone(), value.clone());
            }
        }
        out.insert(key.to_owned(), Value::Object(payload));
    }

    out
}

fn ensure_info_dict(pdf: &mut Document) -> ObjectId {
    if let Ok(Object::Reference(id)) = pdf.trailer.get(b"Info") {
        return *id;
    }

    let id = pdf.new_object_id();
    pdf.objects
        .insert(id, Object::Dictionary(Dictionary::new()));
    pdf.trailer.set("Info", Object::Reference(id));
    id
}

fn clear_existing_correctexam_markers(dict: &mut Dictionary) {
    let keys_to_remove: Vec<Vec<u8>> = dict
        .iter()
        .map(|(key, _)| key.clone())
        .filter(|key| key.starts_with(b"correctexam-"))
        .collect();

    for key in keys_to_remove {
        dict.remove(&key);
    }
}

fn extract_markers_attachment_content(doc: &Document) -> Result<Vec<u8>, AnnotateError> {
    let root_id = doc
        .trailer
        .get(b"Root")?
        .as_reference()
        .map_err(|_| AnnotateError::InvalidPdf("Root is not a reference"))?;

    let root = doc
        .get_object(root_id)?
        .as_dict()
        .map_err(|_| AnnotateError::InvalidPdf("Root is not a dictionary"))?;

    let names_obj = match root.get(b"Names") {
        Ok(obj) => obj,
        Err(_) => return Err(AnnotateError::MissingMarkersAttachment),
    };

    let names_dict = resolve_dict(doc, names_obj)?;
    let embedded_files_obj = names_dict
        .get(b"EmbeddedFiles")
        .map_err(|_| AnnotateError::MissingMarkersAttachment)?;
    let embedded_files_dict = resolve_dict(doc, embedded_files_obj)?;

    let mut pairs = Vec::new();
    collect_name_tree_pairs(doc, embedded_files_dict, &mut pairs)?;

    for (name, file_spec_obj) in pairs {
        let normalized = name.trim_start_matches('/');
        if normalized == ATTACHMENT_NAME {
            let file_spec = resolve_dict(doc, &file_spec_obj)?;
            let ef_obj = file_spec
                .get(b"EF")
                .map_err(|_| AnnotateError::InvalidPdf("FileSpec missing EF"))?;
            let ef_dict = resolve_dict(doc, ef_obj)?;
            let stream_obj = ef_dict
                .get(b"UF")
                .or_else(|_| ef_dict.get(b"F"))
                .map_err(|_| AnnotateError::InvalidPdf("EF missing UF/F"))?;
            let stream = resolve_stream(doc, stream_obj)?;
            return Ok(stream
                .decompressed_content()
                .unwrap_or_else(|_| stream.content.clone()));
        }
    }

    Err(AnnotateError::MissingMarkersAttachment)
}

fn collect_name_tree_pairs(
    doc: &Document,
    node: &Dictionary,
    out: &mut Vec<(String, Object)>,
) -> Result<(), AnnotateError> {
    if let Ok(names_obj) = node.get(b"Names") {
        let names_arr = resolve_array(doc, names_obj)?;
        for chunk in names_arr.chunks(2) {
            if chunk.len() != 2 {
                continue;
            }
            let name = pdf_object_to_text(doc, &chunk[0])?;
            out.push((name, chunk[1].clone()));
        }
    }

    if let Ok(kids_obj) = node.get(b"Kids") {
        let kids = resolve_array(doc, kids_obj)?;
        for kid in kids {
            let kid_dict = resolve_dict(doc, kid)?;
            collect_name_tree_pairs(doc, kid_dict, out)?;
        }
    }

    Ok(())
}

fn resolve_array<'a>(doc: &'a Document, obj: &'a Object) -> Result<&'a Vec<Object>, AnnotateError> {
    match obj {
        Object::Reference(id) => doc
            .get_object(*id)?
            .as_array()
            .map_err(|_| AnnotateError::InvalidPdf("referenced object is not an array")),
        _ => obj
            .as_array()
            .map_err(|_| AnnotateError::InvalidPdf("object is not an array")),
    }
}

fn resolve_dict<'a>(doc: &'a Document, obj: &'a Object) -> Result<&'a Dictionary, AnnotateError> {
    match obj {
        Object::Reference(id) => doc
            .get_object(*id)?
            .as_dict()
            .map_err(|_| AnnotateError::InvalidPdf("referenced object is not a dictionary")),
        _ => obj
            .as_dict()
            .map_err(|_| AnnotateError::InvalidPdf("object is not a dictionary")),
    }
}

fn resolve_stream<'a>(
    doc: &'a Document,
    obj: &'a Object,
) -> Result<&'a lopdf::Stream, AnnotateError> {
    match obj {
        Object::Reference(id) => doc
            .get_object(*id)?
            .as_stream()
            .map_err(|_| AnnotateError::InvalidPdf("referenced object is not a stream")),
        _ => obj
            .as_stream()
            .map_err(|_| AnnotateError::InvalidPdf("object is not a stream")),
    }
}

fn pdf_object_to_text(doc: &Document, obj: &Object) -> Result<String, AnnotateError> {
    let resolved = if let Object::Reference(id) = obj {
        doc.get_object(*id)?
    } else {
        obj
    };

    match resolved {
        Object::String(bytes, _) => Ok(String::from_utf8_lossy(bytes).to_string()),
        Object::Name(bytes) => Ok(String::from_utf8_lossy(bytes).to_string()),
        _ => Err(AnnotateError::InvalidPdf("name-tree key is not text")),
    }
}

#[cfg(feature = "wasm")]
mod wasm_api {
    use super::{annotate_pdf_bytes, extract_markers_from_pdf_bytes, AnnotateError};
    use wasm_bindgen::prelude::*;

    fn to_js_error(err: AnnotateError) -> JsValue {
        JsValue::from_str(&err.to_string())
    }

    #[wasm_bindgen(js_name = annotatePdf)]
    pub fn annotate_pdf(pdf_bytes: &[u8]) -> Result<Vec<u8>, JsValue> {
        let (bytes, _summary) = annotate_pdf_bytes(pdf_bytes).map_err(to_js_error)?;
        Ok(bytes)
    }

    #[wasm_bindgen(js_name = extractMarkers)]
    pub fn extract_markers(pdf_bytes: &[u8]) -> Result<String, JsValue> {
        let markers = extract_markers_from_pdf_bytes(pdf_bytes).map_err(to_js_error)?;
        serde_json::to_string(&markers)
            .map_err(|e| JsValue::from_str(&format!("serialize markers error: {e}")))
    }
}

#[cfg(test)]
mod tests {
    use super::build_marker_map;
    use serde_json::json;

    #[test]
    fn marker_map_keeps_unique_keys_without_key_field() {
        let markers = vec![
            json!({"key":"correctexam-lastname","x":1.0,"y":2.0,"w":3.0,"h":4.0,"p":1}),
            json!({"key":"correctexam-lastname","x":9.0}),
            json!({"key":"correctexam-answer-1-1-1","x":5.0,"y":6.0,"w":7.0,"h":8.0,"p":1,"t":"qcm"}),
        ];

        let map = build_marker_map(&markers);
        assert_eq!(map.len(), 2);
        assert!(map.contains_key("correctexam-lastname"));
        assert!(map.contains_key("correctexam-answer-1-1-1"));
        let payload = map.get("correctexam-lastname").unwrap();
        assert!(payload.get("key").is_none());
    }
}
