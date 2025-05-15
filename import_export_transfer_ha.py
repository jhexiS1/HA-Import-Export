import requests
import json
import argparse
import os
import subprocess
import shutil
from getpass import getpass

def prompt_if_missing(prompt_text, current_val):
    return current_val if current_val else input(f"{prompt_text}: ")

# Argument parser
parser = argparse.ArgumentParser(description="SentinelOne HyperAutomation Import/Export Tool")
parser.add_argument("--mode", choices=["import", "export", "transfer"], required=True, help="Action to perform")
parser.add_argument("--file", help="Workflow JSON file for import")
parser.add_argument("--folder", help="Local folder path to import/export")
parser.add_argument("--github", help="GitHub repo URL to pull workflows from")
parser.add_argument("--url", help="Source SentinelOne console URL")
parser.add_argument("--token", help="Source API token")
parser.add_argument("--target-url", help="Target console URL (for transfer)")
parser.add_argument("--target-token", help="Target API token (for transfer)")
args = parser.parse_args()

# Prompt for required info if missing
console_url = prompt_if_missing("Source console URL", args.url)
api_token = prompt_if_missing("Source API token", args.token or getpass("Source API token: "))

headers = {
    "Authorization": f"ApiToken {api_token}",
    "Content-Type": "application/json"
}

# Clone GitHub repo if specified
if args.github:
    print(f"🔽 Cloning GitHub repo: {args.github}")
    args.folder = "./_repo_clone"
    subprocess.run(["git", "clone", "--depth", "1", args.github, args.folder], check=True)

# Helper: Import a single file
def import_workflow(file, target_url, target_token):
    with open(file, 'r') as f:
        data = json.load(f)
    print(f"📤 Importing workflow: {file}")
    resp = requests.post(f"{target_url}/web/api/v2.1/hyperautomation/workflows/import",
                         headers={"Authorization": f"ApiToken {target_token}",
                                  "Content-Type": "application/json"},
                         json=data)
    if resp.ok:
        print("✅ Success")
    else:
        print(f"❌ Error {resp.status_code}: {resp.text}")

# Helper: Export all workflows
def export_workflows_to_folder(folder):
    print("📥 Fetching all workflows...")
    resp = requests.get(f"{console_url}/web/api/v2.1/hyperautomation/workflows", headers=headers)
    if not resp.ok:
        print(f"❌ Error fetching workflows: {resp.status_code} - {resp.text}")
        return
    workflows = resp.json().get("data", [])
    os.makedirs(folder, exist_ok=True)
    for wf in workflows:
        wf_id = wf["id"]
        wf_detail = requests.get(f"{console_url}/web/api/v2.1/hyperautomation/workflows/{wf_id}", headers=headers)
        if wf_detail.ok:
            wf_data = wf_detail.json().get("data", {})
            filename = os.path.join(folder, f"{wf_data['name'].replace(' ', '_')}.json")
            with open(filename, "w") as f:
                json.dump(wf_data, f, indent=2)
            print(f"✅ Exported: {filename}")
        else:
            print(f"❌ Failed to fetch workflow {wf_id}: {wf_detail.status_code}")

# Execute mode
if args.mode == "import":
    if args.file:
        import_workflow(args.file, console_url, api_token)
    elif args.folder:
        for file in os.listdir(args.folder):
            if file.endswith(".json"):
                import_workflow(os.path.join(args.folder, file), console_url, api_token)
        if args.github:
            shutil.rmtree(args.folder, ignore_errors=True)
    else:
        print("❌ Please provide --file, --folder, or --github for import mode.")

elif args.mode == "export":
    if not args.folder:
        print("❌ Please provide --folder to export workflows.")
    else:
        export_workflows_to_folder(args.folder)

elif args.mode == "transfer":
    target_url = prompt_if_missing("Target console URL", args.target_url)
    target_token = prompt_if_missing("Target API token", args.target_token or getpass("Target API token: "))
    temp_folder = "./_tmp_export"
    export_workflows_to_folder(temp_folder)
    for file in os.listdir(temp_folder):
        if file.endswith(".json"):
            import_workflow(os.path.join(temp_folder, file), target_url, target_token)
    shutil.rmtree(temp_folder, ignore_errors=True)
