# Markdown.nvim

Preview markdowns within a vim buffer

## Requirements

- Pandoc
- ImageMagick
- Chrome
- Cargo to install converter
- Depends on image.nvim for displaying image in window

## Installation

### Lazy

```lua
{
    "misaelaguayo/markdown.nvim",
    build = "cargo build --release",
    opts = {},
    dependencies = {
        { 
            "3rd/image.nvim", 
            build = false,
            opts = {
                processor = "magick_cli",
            },
            config = function()
                require("image").setup({
                    backend = "kitty",
                    processor = "magick_cli",
                })
            end
        }
    }
},
```

### Opts

Optionally pass in `converter_bin` to specify the path to the converter binary.
