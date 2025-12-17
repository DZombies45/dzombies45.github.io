#!/data/data/com.termux/files/usr/bin/bash

set -e

if [ -z "$1" ]; then
  echo "Usage: ./hugo-project.sh <post-slug> [feature-image]"
  exit 1
fi


TITLE_RAW="$1"
SLUG=$(echo "$TITLE_RAW" \
  | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g' \
  | sed -E 's/^-+|-+$//g')
FEATURE_SRC="$2"

POST_DIR="content/posts/$SLUG"

mkdir -p "$POST_DIR"



# Process feature image
if [ -n "$FEATURE_SRC" ] && [ -f "$FEATURE_SRC" ]; then
	echo "add feature image"
	cp "$FEATURE_SRC" "$POST_DIR/feature.png"
  # echo "Optimizing feature image..."
  # magick "$FEATURE_SRC" \
  #   -resize 1600x900^ \
  #   -gravity center \
  #   -extent 1600x900 \
  #   -quality 82 \
  #   "$POST_DIR/feature.webp"
	cat > "$POST_DIR/index.md" <<EOF
---
draft: true
title: "$TITLE_RAW"
date: $(date +"%Y-%m-%dT%H:%M:%S%z")
featureImage: "feature.png"
tags: ["blog","minecraft"]
comments: true
---

EOF
else
  echo "⚠️ Feature image not provided or not found"
	cat > "$POST_DIR/index.md" <<EOF
---
draft: true
title: "$TITLE_RAW"
date: $(date +"%Y-%m-%dT%H:%M:%S%z")
tags: ["minecraft"]
tags: ["blog","minecraft"]
comments: true
---

EOF
fi

echo "✅ Post created: $POST_DIR"
