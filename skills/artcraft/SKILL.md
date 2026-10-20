---
name: artcraft
description: Create and edit graphics with ArtCraft's VectorCraft (vector illustration, like Illustrator/CorelDRAW) and PhotoCraft (image editing, like Photoshop), driven headless through their MCP servers or CLIs. Use whenever a task needs an image made or changed - app icons, logos, mascots and characters, illustrations, UI art, store screenshots and banners, social images, favicons, SVG/PNG/PDF exports, resizing, recoloring, cropping, filters, layered PSD edits or format conversion - in any project.
---

# ArtCraft: VectorCraft + PhotoCraft

Two open-source apps from ArtCraft (github.com/storytold/vectorcraft and
github.com/storytold/photocraft, MIT or Apache-2.0), installed here as
command-line tools with MCP servers:

| Tool | Use it for | MCP server | CLI |
|---|---|---|---|
| **VectorCraft** | Anything drawn: icons, logos, mascots, illustrations, flat UI art, posters, charts. Exports SVG, PDF, PNG, JPG, WebP, EPS, PSD... | `vectorcraft` | `vectorcraft-cli` |
| **PhotoCraft** | Anything pixel: editing photos and screenshots, layers, masks, adjustments (curves, levels, hue), filters, layer styles, PSD files, batch resize/convert | `photocraft` | `photocraft-cli` |

Rule of thumb: **draw in VectorCraft, finish pixels in PhotoCraft.** A mascot,
icon or logo starts as vectors (crisp at every size), then gets exported to
PNG at the sizes needed; PhotoCraft is for photos, screenshots and effects
that only make sense on pixels.

## Before you start

1. Check the tools are there: `command -v vectorcraft-cli photocraft-cli`.
   If not, install them: `bash ~/artcraft-tools/install.sh` (or clone
   `carloshreinertsilva/artcraft-tools` first). The README there explains
   the setup.
2. Prefer the MCP tools (`mcp__vectorcraft__*`, `mcp__photocraft__*`) when
   they are loaded: every call returns its result, and `render_preview` /
   `screenshot` let you **look at the image** before exporting. Fall back to
   the CLI (`run` / `batch`) when the MCP server is not loaded in this
   session.
3. Work in a scratch folder, keep the editable source (`.vectorcraft`,
   `.psd`) next to the exports, and only copy finished files into the
   project.

## VectorCraft (MCP)

Every menu item is a command; the main tools:

- `run_command {command:"file.new", params:{width, height}}`: new document
  (sizes in points = px at 1x).
- `draw_shape`: `rectangle`/`ellipse` (`x,y,width,height`, `radius` for
  rounded corners), `polygon`, `star`, `line`; with `fill`, `stroke`,
  `strokeWidth`, `opacity`, `name`, `effects`.
- `draw_path {d:"M..."}`: SVG path data, or `points` with Bezier handles.
- `add_text {text, x, y, size, font, color, justify}`.
- `pathfinder {operation:"unite"|"minusFront"|...}`, `transform`,
  `apply_effect` (drop shadow, outer glow... call it without `effect` for
  the catalogue), gradients through `set_paint`.
- `command_batch {steps:[...], atomic:true}` to send many steps at once
  (`"$N.id"` refers to an object made by step N).
- `render_preview {max_side}`: **look at it** after every few steps.
- `export {path, format:"png", scale}` / `save_file {path:"x.vectorcraft"}`.
- `list_commands {filter}` / resource `vectorcraft://commands` to discover
  more; `open_file` reads SVG, PDF, AI, EPS, PNG, PSD...

Headless CLI equivalent:

```sh
vectorcraft-cli run --cmd file.new --params '{"width":1024,"height":1024}' \
  --cmd shape.ellipse --params '{"x":112,"y":112,"width":800,"height":800}' \
  --export out.svg --export out.png --scale 1
vectorcraft-cli commands            # full command catalogue (JSON)
vectorcraft-cli convert in.svg out.pdf
```

## PhotoCraft (MCP)

- `command_list {filter}` to find command ids (500+), `command_run {id,
  params}`, `command_batch {steps}`.
- `doc_inspect` (layers, history), `render_preview {max_side}` to look at
  the result.
- Experiment on a copy: `command_run {id:"image.duplicate"}`.
- Files must be inside the folders the server was started with
  (`--automation-read-root` / `--automation-write-root`, see install.sh);
  use paths under them.

Headless CLI:

```sh
photocraft-cli run in.png --cmd image.imageSize --params '{"width":512,"height":512}' --out out.png
photocraft-cli batch --actions actions.json --in ./raw --out ./done
photocraft-cli --help               # every subcommand explains itself
```

## Recipes

- **App icon (Android/iOS/web):** draw at 1024x1024 in VectorCraft, keep
  the subject inside the central ~80% (Android adaptive icons crop to a
  circle), export PNG at 1024, 512 (Play Store), 192, 180, 152, 120, 48 and
  a favicon at 32/16. Look at the 48 px one: if it stops reading, simplify.
- **Mascot / character:** build from simple shapes (ellipses, rounded
  rectangles, a few paths), name every part (`name`), group by body part,
  and keep a `.vectorcraft` master so poses and expressions are edits, not
  redraws. Export transparent PNG at 2x/3x for apps, SVG for the web.
- **Store screenshots / banners:** compose real screenshots (PhotoCraft:
  canvas size, layers, text) with the brand colours; export PNG/JPG at the
  exact sizes the store asks for.
- **Check your work:** always `render_preview` before handing a file over,
  and describe what you see; fix what does not look right.
