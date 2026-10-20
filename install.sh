#!/usr/bin/env bash
# Installs the ArtCraft command-line tools (VectorCraft, PhotoCraft, FigCraft,
# PdfCraft, DesignCraft), the "artcraft" skill and their MCP servers for
# Claude Code. Safe to run again: it replaces what an earlier run installed.
#
#   bash install.sh             # everything
#   ARTCRAFT_NO_MCP=1 bash ...  # skip registering the MCP servers
#
# Files the MCP servers may read and write: ARTCRAFT_ROOT (default: $HOME).
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
arch="$(uname -m)"
bin_src="$here/bin/linux-$arch"
bin_dir="${ARTCRAFT_BIN_DIR:-/usr/local/bin}"
root="${ARTCRAFT_ROOT:-$HOME}"
tools=(vectorcraft photocraft figcraft pdfcraft designcraft)

if [ "$(uname -s)" != "Linux" ] || [ ! -d "$bin_src" ]; then
  echo "artcraft: no prebuilt tools for $(uname -s) $arch; see README.md to build them" >&2
  exit 1
fi

mkdir -p "$bin_dir"
installed=()
for t in "${tools[@]}"; do
  src="$bin_src/$t-cli.xz"
  [ -f "$src" ] || { echo "artcraft: $t-cli not in this repository, skipped" >&2; continue; }
  xz -dc "$src" > "$bin_dir/$t-cli.tmp"
  chmod +x "$bin_dir/$t-cli.tmp"
  mv "$bin_dir/$t-cli.tmp" "$bin_dir/$t-cli"
  installed+=("$t")
done

# The skill, for every project.
mkdir -p "$HOME/.claude/skills"
rm -rf "$HOME/.claude/skills/artcraft"
cp -r "$here/skills/artcraft" "$HOME/.claude/skills/artcraft"

# MCP servers, user scope (all projects). Headless, confined to $root.
if [ -z "${ARTCRAFT_NO_MCP:-}" ] && command -v claude >/dev/null 2>&1; then
  for t in "${installed[@]}"; do
    claude mcp remove --scope user "$t" >/dev/null 2>&1 || true
    case "$t" in
      vectorcraft) args=(mcp --headless --automation-read-root "$root" --automation-write-root "$root") ;;
      *) args=(mcp --automation-read-root "$root" --automation-write-root "$root") ;;
    esac
    claude mcp add --scope user "$t" -- "$bin_dir/$t-cli" "${args[@]}" >/dev/null
  done
fi

echo "artcraft: ${installed[*]} in $bin_dir; skill in ~/.claude/skills/artcraft"
