#!/data/data/com.termux/files/usr/bin/bash

SRC="$1"
DEST="$2"

if [ -z "$SRC" ] || [ -z "$DEST" ]; then
  echo "Usage: ./optimize-images.sh <src-folder> <dest-folder>"
  exit 1
fi

mkdir -p "$DEST"

for img in "$SRC"/*.{png,jpg,jpeg}; do
  [ -e "$img" ] || continue

  name=$(basename "$img")
  base="${name%.*}"

  echo "Optimizing $name"

  magick "$img" \
    -resize 1920x \
    -quality 80 \
    "$DEST/$base.webp"
done
