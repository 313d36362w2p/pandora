#!/bin/bash

# Default image tag
IMAGE_TAG="pandora"

# Define the image name (can be set dynamically for other images like "ubuntu", "centos", etc.)
IMAGE_NAME="debian"

ARCHITECTURES_FILE="${IMAGE_NAME}-architecture-cache"

# Check if the available architectures are already cached
if [ ! -f "$ARCHITECTURES_FILE" ]; then
  # Fetch available architectures and variants, and exclude "unknown" variants
  AVAILABLE_ARCHITECTURES=$(docker manifest inspect "$IMAGE_NAME:latest" | jq -r '.manifests[] | select(.platform.architecture != null and .platform.architecture != "unknown") | "\(.platform.architecture)-\(.platform.variant // "none")"')
  
  # Cache the result to a local file
  echo "$AVAILABLE_ARCHITECTURES" > "$ARCHITECTURES_FILE"
else
  # Load the cached architectures
  AVAILABLE_ARCHITECTURES=$(cat "$ARCHITECTURES_FILE")
fi

# Create a reformatted version for easy printing
FORMATTED_AVAILABLE_ARCHITECTURES=$(echo $AVAILABLE_ARCHITECTURES | tr '\n' ',' | sed 's/,$//')

# Check if architecture argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <architecture> <variant> <environment-type>"
  echo "Available architectures (architecture-variant): "
  echo $FORMATTED_AVAILABLE_ARCHITECTURES
  exit 1
fi

# Check if variant argument is provided.
if [ -z "$2" ]; then
  echo "Usage: $0 <architecture> <variant> <environment-type>"
  echo "Available architectures (architecture-variant):"
  echo $FORMATTED_AVAILABLE_ARCHITECTURES
  exit 1
fi

# Assign the architecture and variant argument to variables
ARCHITECTURE=$1
VARIANT=$2

# Check if the requested architecture-variant exists in the cache
if ! echo "$AVAILABLE_ARCHITECTURES" | grep -q "^$ARCHITECTURE-$VARIANT$"; then
  echo "Usage: $0 <architecture> <variant> <environment-type>"
  echo "Error: Architecture-Variant '$ARCHITECTURE-$VARIANT' is not available. Available architectures: "
  echo $FORMATTED_AVAILABLE_ARCHITECTURES
  exit 1
fi

# Check if VM type argument is provided
if [ -z "$3" ]; then
  echo "Usage: $0 $ARCHITECTURE $VARIANT <environment-type>"
  echo "Example: $0 $ARCHITECTURE $VARIANT (main, custom)"
  echo "The 'main' type contains all tools, usually used with the host architecture."
  echo "The 'custom' type contains minimal tools, usually used with the more obscure architectures."
  exit 1
fi

# Assign the type argument to variables
TYPE=$3


# Build the container image with the specified variant
podman build --arch $ARCHITECTURE --variant $VARIANT -t "$ARCHITECTURE-$VARIANT-$TYPE-$IMAGE_TAG" environment/"$TYPE"

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Build successful."
else
    echo "Build failed."
    exit 1
fi
