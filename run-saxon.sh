#!/usr/bin/env bash

# Exit on error
set -e

# Validate inputs
INPUT="$1"
XSL="$2"
OUTPUT="$3"

if [[ -z "$INPUT" || -z "$XSL" || -z "$OUTPUT" ]]; then
  echo "Usage: ./run-saxon input.xml stylesheet.xsl output.xml"
  exit 1
fi

# Paths
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SAXON_DIR="$SCRIPT_DIR/saxon"
INPUT_FILE="$SCRIPT_DIR/_input/$INPUT"
XSL_FILE="$SCRIPT_DIR/$XSL"
OUTPUT_FILE="$SCRIPT_DIR/_output/$OUTPUT"

# Ensure _output folder exists
mkdir -p "$SCRIPT_DIR/_output"

# Use provided SAXON_JAR or default
if [ -z "$SAXON_JAR" ]; then
  SAXON_JAR="$SAXON_DIR/saxon-he-12.9.jar"
fi

# Verify that the JAR file exists
if [ ! -f "$SAXON_JAR" ]; then
  echo "Error: Saxon JAR not found at $SAXON_JAR"
  exit 1
fi

# Run Saxon
java -jar "$SAXON_JAR" \
  -s:"$INPUT_FILE" -xsl:"$XSL_FILE" -o:"$OUTPUT_FILE"
