# SentinelOne HyperAutomation Workflow Toolkit

## 📦 Overview

This toolkit provides command-line tools to **import**, **export**, and **transfer** HyperAutomation workflows for SentinelOne consoles. It supports:

- Single-file or batch imports
- Workflow export for backup or auditing
- Console-to-console migration
- Support for **Python**, **PowerShell**, and **Bash** on **macOS**, **Linux**, **Windows**, and **Kubernetes**

---

## 🚀 Features

- 🌐 Interact directly with the SentinelOne HyperAutomation REST API
- 🧠 Prompt-driven or environment-variable CLI usage
- 🔒 Secure API token handling
- 📂 Operate on local folders or downloaded GitHub repos
- 📤 Verbose feedback per file processed
- 🛠 Transfer entire workflow libraries between SentinelOne environments

---

## 🧰 Scripts Summary

| File | Type | Platform | Purpose |
|------|------|----------|---------|
| `import_export_transfer_ha.py` | Python | Cross-platform | All features, full prompts, robust validation |
| `import_export_transfer_ha.ps1` | PowerShell | Windows | GUI-less batch or scheduled automation |
| `import_export_transfer_ha.sh` | Bash | macOS/Linux/K8s | Cron/scheduled friendly CLI version |

---

## 🔐 Prerequisites

1. **SentinelOne Console Access**
   - Your console URL (e.g., `https://usea1-purple.sentinelone.net`)
   - Your API token from **My User > API Tokens**
     - Must have `Manage Workflows` permission or admin access.

2. **Tools Installed**
   - `jq`, `curl` for Bash
   - `requests` for Python
   - PowerShell 5.0+ on Windows

---

## 🔑 Authentication & Configuration

Each script accepts API keys and URLs via:
1. **Command-line arguments**
2. **Environment variables**:
   - `SRC_URL`, `SRC_TOKEN` (for source console)
   - `TGT_URL`, `TGT_TOKEN` (for destination console)

---

## 🧪 Usage Examples

### ✅ Python

```bash
# Export all workflows to ./backup/
python3 import_export_transfer_ha.py --mode export --url $SRC_URL --token $SRC_TOKEN --folder ./backup

# Import workflows from folder
python3 import_export_transfer_ha.py --mode import --url $TGT_URL --token $TGT_TOKEN --folder ./backup

# Transfer workflows between consoles
python3 import_export_transfer_ha.py --mode transfer --url $SRC_URL --token $SRC_TOKEN --target-url $TGT_URL --target-token $TGT_TOKEN
```

### ✅ PowerShell

```powershell
# Export
./import_export_transfer_ha.ps1 -mode export -url $SRC_URL -token $SRC_TOKEN -folder ./exported

# Import
./import_export_transfer_ha.ps1 -mode import -url $TGT_URL -token $TGT_TOKEN -folder ./exported

# Transfer
./import_export_transfer_ha.ps1 -mode transfer -url $SRC_URL -token $SRC_TOKEN -targetUrl $TGT_URL -targetToken $TGT_TOKEN
```

### ✅ Bash

```bash
# Export
SRC_URL="https://usea1.sentinelone.net" SRC_TOKEN="abc123" ./import_export_transfer_ha.sh export ./dump

# Import
TGT_URL="https://target.sentinelone.net" TGT_TOKEN="xyz789" ./import_export_transfer_ha.sh import ./dump

# Transfer
SRC_URL="..." SRC_TOKEN="..." TGT_URL="..." TGT_TOKEN="..." ./import_export_transfer_ha.sh transfer ./xfer
```

---

## ⚙️ CLI Flags

### Python
| Flag | Required | Description |
|------|----------|-------------|
| `--mode` | ✅ | `import`, `export`, or `transfer` |
| `--url` | ✅ | Source console URL |
| `--token` | ✅ | API token for source console |
| `--target-url` | Only for `transfer` | Target console URL |
| `--target-token` | Only for `transfer` | API token for target console |
| `--folder` | For import/export | Folder path with JSON workflows |
| `--file` | For single import | JSON file to import |

---

## 🧼 Best Practices

- Use temporary service tokens for automation
- Store tokens in secret vaults or pass via secure CI/CD tools
- Audit exports regularly
- Use transfer mode to promote tested workflows between staging → prod

---

## 📄 License

MIT License

© 2025 The PurpleOne Team

---

## 🤝 Contributing

Feature requests welcome. Pull requests must include:
- Script + test examples
- Clear parameter validation
