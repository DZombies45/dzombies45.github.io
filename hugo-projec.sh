#!/data/data/com.termux/files/usr/bin/bash

set -e

if [ -z "$1" ]; then
  echo "Usage: ./hugo-project.sh <post-slug> [feature-image]"
  exit 1
fi

SLUG="$1"
FEATURE_SRC="$2"

POST_DIR="content/posts/$SLUG"
IMG_DIR="$POST_DIR/images"

mkdir -p "$IMG_DIR"

# Create index.md
cat > "$POST_DIR/index.md" <<EOF
---
title: "$SLUG"
date: $(date +"%Y-%m-%dT%H:%M:%S%z")
draft: true
featureImage: "feature.webp"
tags: ["project", "minecraft"]
---

EOF

# Process feature image
if [ -n "$FEATURE_SRC" ] && [ -f "$FEATURE_SRC" ]; then
  echo "Optimizing feature image..."
  magick "$FEATURE_SRC" \
    -resize 1600x900^ \
    -gravity center \
    -extent 1600x900 \
    -quality 82 \
    "$POST_DIR/feature.webp"
else
  echo "⚠️ Feature image not provided or not found"
fi

echo "✅ Post created: $POST_DIR"
