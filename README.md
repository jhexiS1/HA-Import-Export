# SentinelOne HyperAutomation Workflow Toolkit

## 📦 Overview

This toolkit lets you **import**, **export**, and **transfer** SentinelOne HyperAutomation workflows between consoles, folders, and even GitHub repos.

## 🔐 Prerequisites

- SentinelOne API token with `Manage Workflows` permission (from **My User > API Tokens** in SOC view).
- Console URL (e.g., `https://your-console.sentinelone.net`)
- Tools: Python 3, PowerShell 5+, Git, jq, curl

## 🧰 Included Scripts

| File | Type | Platform | Features |
|------|------|----------|----------|
| `import_export_transfer_ha.py` | Python | Cross-platform | Full prompt-driven CLI with GitHub support |
| `import_export_transfer_ha.ps1` | PowerShell | Windows | Batch automation + GitHub import |
| `import_export_transfer_ha.sh` | Bash | macOS/Linux/K8s | GitHub folder import, automation-friendly |

---

## 🧪 Usage Examples

### 🔄 Import from GitHub

```bash
python3 import_export_transfer_ha.py --mode import --github https://github.com/org/s1-workflows --url $TGT_URL --token $TGT_TOKEN
./import_export_transfer_ha.ps1 -mode import -github https://github.com/org/s1-workflows -url $TGT_URL -token $TGT_TOKEN
./import_export_transfer_ha.sh import ./tmp https://github.com/org/s1-workflows
```

### 💾 Export from Console

```bash
python3 import_export_transfer_ha.py --mode export --url $SRC_URL --token $SRC_TOKEN --folder ./exported
```

### 🔁 Transfer Between Consoles

```bash
python3 import_export_transfer_ha.py --mode transfer --url $SRC_URL --token $SRC_TOKEN --target-url $TGT_URL --target-token $TGT_TOKEN
```

---

## ⚙️ CLI Flags

| Flag | Description |
|------|-------------|
| `--mode` | Required. One of `import`, `export`, `transfer` |
| `--file` | JSON file to import (single) |
| `--folder` | Directory with JSON workflows |
| `--github` | URL of public GitHub repo to clone |
| `--url`, `--token` | Source console details |
| `--target-url`, `--target-token` | Destination console for transfer |

---

## 📁 Output

- Exports saved as `.json` files with the workflow name
- Logs display per-workflow status
- Temporary folders auto-cleaned

---

## 🛡️ Security Best Practices

- Never hardcode tokens in code
- Use environment variables in CI/CD
- Use dedicated API accounts with minimal scope

---

## 🧼 Cleanup

Temporary folders like `_repo_clone` and `_tmp_export` are deleted after use.

---

## 📄 License

MIT License

© 2025 The PurpleOne Team
