# SentinelOne HyperAutomation Workflow Toolkit

## 📦 Overview

This repository provides an advanced toolkit to automate the import, export, and transfer of SentinelOne HyperAutomation workflows. It supports:

- Batch operations (folders of JSON files)
- Console-to-console workflow migration
- GitHub and local directory sourcing
- Full CLI scripts for Python, PowerShell, and Bash (macOS/Linux/K8s)

## 🧰 Scripts Included

| Script | Platform | Description |
|--------|----------|-------------|
| `import_export_transfer_ha.py` | Python | Full-featured import/export/transfer with prompts and error handling |
| `import_export_transfer_ha.ps1` | PowerShell | Windows-compatible script for importing, exporting, and transferring workflows |
| `import_export_transfer_ha.sh` | Bash | macOS/Linux/K8s version supporting CLI variables and folder-based operations |

---

## 🚀 Setup

1. Clone this repo or download the ZIP.
2. Place your SentinelOne API credentials and console URLs as either environment variables or provide them during execution.
3. Ensure you have `jq` and `curl` (for bash), or `requests` module (for Python).

---

## 🧪 Usage Examples

### 🔄 Import Workflows

```bash
python3 import_export_transfer_ha.py --mode import --folder ./my_workflows
./import_export_transfer_ha.ps1 -mode import -folder ./my_workflows
./import_export_transfer_ha.sh import ./my_workflows
```

### 💾 Export Workflows

```bash
python3 import_export_transfer_ha.py --mode export --folder ./backup
./import_export_transfer_ha.ps1 -mode export -folder ./backup
./import_export_transfer_ha.sh export ./backup
```

### 🔁 Transfer Workflows

```bash
python3 import_export_transfer_ha.py --mode transfer --url https://source.s1.net --token src123 --target-url https://target.s1.net --target-token tgt456
./import_export_transfer_ha.ps1 -mode transfer -url https://source.s1.net -token src123 -targetUrl https://target.s1.net -targetToken tgt456
./import_export_transfer_ha.sh transfer ./tmp_transfer
```

---

## 🔐 Security Notice

- Do not hardcode credentials in shared versions of these scripts.
- Use environment variables or secure vaults where possible.

---

## 📄 License

MIT License

© 2025 The PurpleOne Team
