#!/usr/bin/env bash
set -e

MODELFILES_DIR="$(dirname "$0")/modelfiles"

echo "Reconciling Ollama local state..."

# 1. Iterate over every .modelfile in the directory
for FILE in "$MODELFILES_DIR"/*.modelfile; do
  # Extract the intended model name from the filename (e.g., adr_planner_capped)
  MODEL_NAME=$(basename "$FILE" .modelfile)

  # 2. Extract the base model from the FROM directive
  BASE_MODEL=$(grep -i '^FROM ' "$FILE" | awk '{print $2}')

  echo "Processing: $MODEL_NAME (Base: $BASE_MODEL)"

  # 3. Ensure the base model exists (pull if missing)
  if ! ollama list | grep -q "^${BASE_MODEL} "; then
    echo "  -> Pulling base model $BASE_MODEL..."
    ollama pull "$BASE_MODEL"
  fi

  # 4. Compile the custom model
  echo "  -> Compiling $MODEL_NAME..."
  ollama create "$MODEL_NAME" -f "$FILE"
done

echo "Ollama state reconciled successfully."
