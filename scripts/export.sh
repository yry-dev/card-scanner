#!/usr/bin/env bash
# Export the printable parts of card-scanner.scad as 3MF files.
#
# Usage:
#   scripts/export.sh [OUT_DIR] [PART ...]
#
# OUT_DIR defaults to export/ next to the .scad file. With no PART, every
# part is exported. Parts: base, pillar, pin, plate. The pillar is exported
# pad-down, ready to print.
#
# Set OPENSCAD to the binary path if it is not on PATH.

set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
scad="$here/../card-scanner.scad"
out="${1:-$here/../export}"
[ $# -gt 0 ] && shift
parts=("$@")
[ ${#parts[@]} -eq 0 ] && parts=(base pillar pin plate)

find_openscad() {
    if [ -n "${OPENSCAD:-}" ]; then printf '%s\n' "$OPENSCAD"; return; fi
    if command -v openscad >/dev/null 2>&1; then command -v openscad; return; fi
    for c in /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD \
             /usr/bin/openscad /usr/local/bin/openscad /snap/bin/openscad; do
        [ -x "$c" ] && { printf '%s\n' "$c"; return; }
    done
    echo "openscad not found; set OPENSCAD to the binary path" >&2
    exit 2
}
bin="$(find_openscad)"

# Manifold is much faster than CGAL; use it when this build supports it.
backend=()
if "$bin" --help 2>&1 | grep -q -- '--backend'; then backend=(--backend=Manifold); fi

mkdir -p "$out"
pids=()
for part in "${parts[@]}"; do
    case "$part" in
        base|pin|plate) scad_part="$part" ;;
        pillar)         scad_part="print_pillar" ;;
        *) echo "unknown part: $part (base, pillar, pin, plate)" >&2; exit 2 ;;
    esac
    echo "exporting $part"
    "$bin" "${backend[@]}" -D "part=\"$scad_part\"" -o "$out/card-scanner-$part.3mf" "$scad" \
        > "$out/card-scanner-$part.log" 2>&1 &
    pids+=($!)
done

status=0
for pid in "${pids[@]}"; do wait "$pid" || status=1; done
grep -h "ECHO: \"WARNING" "$out"/card-scanner-*.log || true
if [ $status -ne 0 ]; then
    echo "an export failed; see the .log files in $out" >&2
    exit 1
fi
rm -f "$out"/card-scanner-*.log
ls -l "$out"/card-scanner-*.3mf
