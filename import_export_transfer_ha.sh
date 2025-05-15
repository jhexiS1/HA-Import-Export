#!/bin/bash

SRC_URL="${SRC_URL:-}"
SRC_TOKEN="${SRC_TOKEN:-}"
TGT_URL="${TGT_URL:-}"
TGT_TOKEN="${TGT_TOKEN:-}"
MODE="$1"
FOLDER="$2"

function import_workflow() {
  local wf_file="$1"
  echo "📤 Importing: $wf_file"
  curl -s -X POST "$TGT_URL/web/api/v2.1/hyperautomation/workflows/import" \
    -H "Authorization: ApiToken $TGT_TOKEN" \
    -H "Content-Type: application/json" \
    -d @"$wf_file" > /dev/null && echo "✅ Imported: $wf_file" || echo "❌ Failed: $wf_file"
}

function export_workflows() {
  mkdir -p "$FOLDER"
  echo "📥 Exporting workflows from $SRC_URL"
  curl -s -H "Authorization: ApiToken $SRC_TOKEN" "$SRC_URL/web/api/v2.1/hyperautomation/workflows" | jq -c '.data[]' | while read -r wf; do
    wf_id=$(echo "$wf" | jq -r '.id')
    wf_name=$(curl -s -H "Authorization: ApiToken $SRC_TOKEN" "$SRC_URL/web/api/v2.1/hyperautomation/workflows/$wf_id" | jq -r '.data.name' | tr ' ' '_')
    curl -s -H "Authorization: ApiToken $SRC_TOKEN" "$SRC_URL/web/api/v2.1/hyperautomation/workflows/$wf_id" | jq '.data' > "$FOLDER/$wf_name.json"
    echo "✅ Exported: $wf_name.json"
  done
}

case "$MODE" in
  "export")
    export_workflows
    ;;
  "import")
    for wf in "$FOLDER"/*.json; do
      import_workflow "$wf"
    done
    ;;
  "transfer")
    TMPDIR="./_tmp_ha_export"
    mkdir -p "$TMPDIR"
    export_workflows "$TMPDIR"
    for wf in "$TMPDIR"/*.json; do
      import_workflow "$wf"
    done
    ;;
  *)
    echo "Usage: $0 <export|import|transfer> <folder>"
    ;;
esac
