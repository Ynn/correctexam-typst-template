import init, { annotatePdf } from "./pkg/annotate_typst.js";

const dropZone = document.getElementById("drop-zone");
const fileInput = document.getElementById("file-input");
const annotateBtn = document.getElementById("annotate-btn");
const downloadBtn = document.getElementById("download-btn");
const statusEl = document.getElementById("status");
const inputNameEl = document.getElementById("input-name");
const outputNameEl = document.getElementById("output-name");

let wasmReady = false;
let inputBytes = null;
let inputName = "";
let outputBytes = null;
let outputName = "";

function setStatus(message) {
  statusEl.textContent = message;
}

function deriveOutputName(name) {
  if (name.toLowerCase().endsWith(".pdf")) {
    return `${name.slice(0, -4)}.annotated.pdf`;
  }
  return `${name}.annotated.pdf`;
}

async function ensureWasm() {
  if (!wasmReady) {
    setStatus("Loading annotation engine...");
    await init();
    wasmReady = true;
  }
}

async function loadFile(file) {
  if (!file) {
    return;
  }
  const lower = file.name.toLowerCase();
  if (!(lower.endsWith(".pdf") || file.type === "application/pdf")) {
    setStatus("Only PDF files are accepted.");
    return;
  }

  const buffer = await file.arrayBuffer();
  inputBytes = new Uint8Array(buffer);
  inputName = file.name;
  outputBytes = null;
  outputName = "";

  inputNameEl.textContent = inputName;
  outputNameEl.textContent = "None";
  annotateBtn.disabled = false;
  downloadBtn.disabled = true;
  setStatus("File loaded. Click Annotate.");
}

async function annotateCurrentFile() {
  if (!inputBytes) {
    return;
  }

  try {
    annotateBtn.disabled = true;
    setStatus("Annotating PDF...");

    await ensureWasm();
    const annotated = annotatePdf(inputBytes);

    outputBytes = annotated;
    outputName = deriveOutputName(inputName);

    outputNameEl.textContent = outputName;
    downloadBtn.disabled = false;
    setStatus("Annotation complete.");
  } catch (error) {
    setStatus(`Annotation failed: ${String(error)}`);
  } finally {
    annotateBtn.disabled = !inputBytes;
  }
}

function downloadOutput() {
  if (!outputBytes || !outputName) {
    return;
  }

  const blob = new Blob([outputBytes], { type: "application/pdf" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = outputName;
  a.click();
  URL.revokeObjectURL(url);
}

dropZone.addEventListener("click", () => fileInput.click());
fileInput.addEventListener("change", async (event) => {
  const file = event.target.files?.[0];
  await loadFile(file);
});

dropZone.addEventListener("dragover", (event) => {
  event.preventDefault();
  dropZone.classList.add("dragover");
});

dropZone.addEventListener("dragleave", () => {
  dropZone.classList.remove("dragover");
});

dropZone.addEventListener("drop", async (event) => {
  event.preventDefault();
  dropZone.classList.remove("dragover");
  const file = event.dataTransfer?.files?.[0];
  await loadFile(file);
});

annotateBtn.addEventListener("click", annotateCurrentFile);
downloadBtn.addEventListener("click", downloadOutput);

if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("./sw.js").catch(() => {
    setStatus("Service worker unavailable.");
  });
}
