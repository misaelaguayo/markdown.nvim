use headless_chrome::Browser;
use headless_chrome::LaunchOptionsBuilder;
use headless_chrome::protocol::cdp::Page::CaptureScreenshotFormatOption;
use pandoc::{InputKind, OutputFormat, OutputKind, PandocOption};
use std::fs;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 3 {
        eprintln!("Usage: {} <markdown_file> <output_image_file>", args[0]);
        std::process::exit(1);
    }

    let markdown_file = &args[1];
    let output_image_file = &args[2];

    let markdown = match read_markdown_file(markdown_file) {
        Ok(content) => content,
        Err(e) => {
            eprintln!("Error reading markdown file: {}", e);
            std::process::exit(1);
        }
    };

    let output_file = "output.html";

    match markdown_to_html(&markdown, output_file) {
        Ok(_) => println!(
            "Successfully converted markdown to HTML and saved to {}",
            output_file
        ),
        Err(e) => {
            eprintln!("Error converting markdown to HTML: {}", e);
            std::process::exit(1);
        }
    }

    match html_to_png(output_file, output_image_file) {
        Ok(_) => println!(
            "Successfully converted HTML to PNG and saved to {}",
            output_image_file
        ),
        Err(e) => {
            eprintln!("Error converting HTML to PNG: {}", e);
            std::process::exit(1);
        }
    }
}

fn read_markdown_file(file_path: &str) -> Result<String, Box<dyn std::error::Error>> {
    let content = fs::read_to_string(file_path)?;
    Ok(content)
}

fn markdown_to_html(markdown: &str, output_file: &str) -> Result<(), Box<dyn std::error::Error>> {
    let output_pathbuf = std::path::PathBuf::from(output_file);

    let mut p = pandoc::new();

    p.set_input(InputKind::Pipe(markdown.to_string()));
    p.set_output_format(OutputFormat::Html, vec![]);
    p.set_output(OutputKind::File(output_pathbuf));
    p.add_option(PandocOption::Standalone);

    p.execute()?;
    Ok(())
}

fn html_to_png(html_file: &str, output_file: &str) -> Result<(), Box<dyn std::error::Error>> {
    let launch_options = LaunchOptionsBuilder::default()
        .headless(true)
        .window_size(Some((1080, 5000)))
        .build()
        .unwrap();

    let browser = Browser::new(launch_options)?;
    let tab = browser.new_tab()?;

    tab.navigate_to(&format!(
        "file://{}",
        fs::canonicalize(html_file)?.to_str().unwrap()
    ))?;

    tab.wait_until_navigated()?;

    // trim the page to the content height
    let body = tab.find_element("body")?;
    let box_model = body.get_box_model()?;
    let viewport = box_model.margin_viewport();

    let png_data = tab.capture_screenshot(
        CaptureScreenshotFormatOption::Png,
        None,
        Some(viewport),
        true,
    )?;
    fs::write(output_file, &png_data)?;
    println!("Saved PNG to {}", output_file);

    Ok(())
}
