#[cfg(feature = "native-cli")]
use anyhow::{Context, Result};
#[cfg(feature = "native-cli")]
use annotate_typst::{annotate_pdf_bytes, AnnotationSummary};
#[cfg(feature = "native-cli")]
use clap::Parser;
#[cfg(feature = "native-cli")]
use std::fs;
#[cfg(feature = "native-cli")]
use std::path::{Path, PathBuf};

#[cfg(feature = "native-cli")]
#[derive(Debug, Parser)]
#[command(name = "annotate-ce")]
#[command(about = "Annotate a Typst-generated CorrectExam PDF using embedded markers")]
struct Cli {
    /// Input PDF with attached /correctexam-markers.json
    input: PathBuf,
    /// Output annotated PDF path
    #[arg(short, long)]
    output: Option<PathBuf>,
}

#[cfg(feature = "native-cli")]
fn default_output_path(input: &Path) -> PathBuf {
    let parent = input.parent().unwrap_or_else(|| Path::new("."));
    let stem = input
        .file_stem()
        .and_then(|s| s.to_str())
        .unwrap_or("exam");
    parent.join(format!("{stem}.annotated.pdf"))
}

#[cfg(feature = "native-cli")]
fn write_annotated(path: &Path, bytes: &[u8]) -> Result<()> {
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent)
            .with_context(|| format!("cannot create output directory {}", parent.display()))?;
    }
    fs::write(path, bytes).with_context(|| format!("cannot write {}", path.display()))?;
    Ok(())
}

#[cfg(feature = "native-cli")]
fn print_summary(summary: &AnnotationSummary, output: &Path) {
    println!(
        "ok: {} markers, {} metadata entries",
        summary.marker_count, summary.annotation_count
    );
    println!("output: {}", output.display());
}

#[cfg(feature = "native-cli")]
fn run() -> Result<()> {
    let cli = Cli::parse();
    let input_bytes = fs::read(&cli.input)
        .with_context(|| format!("cannot read {}", cli.input.display()))?;

    let (annotated, summary) = annotate_pdf_bytes(&input_bytes)
        .with_context(|| format!("cannot annotate {}", cli.input.display()))?;

    let output = cli.output.unwrap_or_else(|| default_output_path(&cli.input));
    write_annotated(&output, &annotated)?;
    print_summary(&summary, &output);

    Ok(())
}

#[cfg(feature = "native-cli")]
fn main() {
    if let Err(err) = run() {
        eprintln!("error: {err:#}");
        std::process::exit(1);
    }
}

#[cfg(not(feature = "native-cli"))]
fn main() {
    eprintln!("binary disabled: build with --features native-cli");
    std::process::exit(1);
}
