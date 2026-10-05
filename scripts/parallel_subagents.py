import argparse
import concurrent.futures
import json
import os
import subprocess
import time
import sys
from datetime import datetime

try:
    import yaml
    HAS_YAML = True
except ImportError:
    HAS_YAML = False

def parse_args():
    parser = argparse.ArgumentParser(description="Parallel Subagent Dispatcher")
    parser.add_argument("--tasks", help="JSON/YAML task specification file")
    parser.add_argument("--task", action="append", help="Task specified as <role-or-model>:<task-file>")
    parser.add_argument("--concurrency", type=int, default=4, help="Max parallel worker processes")
    parser.add_argument("--output-dir", default=f".gsd/runs/{datetime.now().strftime('%Y%m%d_%H%M%S')}", help="Base directory for run artifacts")
    parser.add_argument("--report", help="Path to output aggregated markdown or JSON summary report")
    parser.add_argument("--dry-run", action="store_true", help="Pass dry-run down to subagents (mock mode)")
    return parser.parse_args()

def get_role_mappings():
    mappings = {}
    if HAS_YAML and os.path.exists("model_capabilities.yaml"):
        try:
            with open("model_capabilities.yaml", "r") as f:
                data = yaml.safe_load(f)
                if data and "role_mappings" in data:
                    mappings = data["role_mappings"]
        except Exception:
            pass
    return mappings

def load_tasks(args):
    tasks = []
    role_mappings = get_role_mappings()

    if args.tasks:
        with open(args.tasks, 'r') as f:
            if args.tasks.endswith('.yaml') or args.tasks.endswith('.yml'):
                if not HAS_YAML:
                    print("Error: PyYAML not installed. Cannot parse YAML tasks file.", file=sys.stderr)
                    sys.exit(1)
                data = yaml.safe_load(f)
            else:
                data = json.load(f)
            for item in data:
                if "model" in item and item["model"] in role_mappings:
                    item["model"] = role_mappings[item["model"]]
                if "role" in item and "model" not in item:
                    item["model"] = role_mappings.get(item["role"], item["role"])
                tasks.append(item)
    
    if args.task:
        for t in args.task:
            if ":" not in t:
                print(f"Error: Invalid --task format '{t}'. Expected <role-or-model>:<task-file>")
                continue
            model_or_role, file = t.split(":", 1)
            model = role_mappings.get(model_or_role, model_or_role)
            tasks.append({"model": model, "file": file})
    return tasks

def run_subagent(task, i, args):
    task_id = task.get("id", f"task_{i}")
    run_dir = os.path.join(args.output_dir, task_id)
    os.makedirs(run_dir, exist_ok=True)
    
    # Resolve task file or create from prompt
    task_file = task.get("file")
    if not task_file and "prompt" in task:
        task_file = os.path.join(run_dir, "task.md")
        with open(task_file, "w") as f:
            f.write(task["prompt"])
            
    out_json = os.path.join(run_dir, "output.json")
    cmd = ["bash", "scripts/subagent.sh", task["model"], task_file, out_json]
    
    env = os.environ.copy()
    if args.dry_run:
        env["MOCK_AGY"] = "1"
        
    start_time = time.time()
    result = subprocess.run(cmd, env=env, capture_output=True, text=True)
    duration = time.time() - start_time
    
    status = "SUCCESS" if result.returncode == 0 else "FAILED"
    
    response_data = {}
    if os.path.exists(out_json):
        try:
            with open(out_json, "r") as f:
                response_data = json.load(f)
        except json.JSONDecodeError:
            pass
            
    return {
        "task_id": task_id,
        "model": task["model"],
        "file": task_file,
        "status": status,
        "duration": duration,
        "exit_code": result.returncode,
        "stdout": result.stdout,
        "stderr": result.stderr,
        "response": response_data,
        "run_dir": run_dir
    }

def main():
    args = parse_args()
    tasks = load_tasks(args)
    
    if not tasks:
        # Avoid failure on help check
        sys.exit(0)
        
    os.makedirs(args.output_dir, exist_ok=True)
    
    results = []
    success_count = 0
    failure_count = 0
    
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.concurrency) as executor:
        futures = {executor.submit(run_subagent, task, i, args): i for i, task in enumerate(tasks)}
        indexed_results = []
        for future in concurrent.futures.as_completed(futures):
            idx = futures[future]
            res = future.result()
            indexed_results.append((idx, res))
            if res["status"] == "SUCCESS":
                success_count += 1
            else:
                failure_count += 1
                
    indexed_results.sort(key=lambda x: x[0])
    results = [r[1] for r in indexed_results]
    
    report_data = {
        "summary": {
            "total_tasks": len(tasks),
            "success": success_count,
            "failure": failure_count
        },
        "results": results
    }
    
    if args.report:
        if args.report.endswith('.json'):
            with open(args.report, "w") as f:
                json.dump(report_data, f, indent=2)
        else:
            with open(args.report, "w") as f:
                f.write(f"# Execution Report\n\n")
                f.write(f"- **Total Tasks**: {len(tasks)}\n")
                f.write(f"- **Success**: {success_count}\n")
                f.write(f"- **Failure**: {failure_count}\n\n")
                
                f.write("## Results\n\n")
                for r in results:
                    f.write(f"### {r['task_id']} ({r['model']})\n")
                    f.write(f"- **Status**: {r['status']}\n")
                    f.write(f"- **File**: `{r['file']}`\n")
                    f.write(f"- **Duration**: {r['duration']:.2f}s\n")
                    
                    if r["response"]:
                        f.write(f"- **Tokens**: {r['response'].get('tokens', 'N/A')}\n")
                        resp_snippet = str(r['response'].get('response', ''))[:100].replace('\n', ' ')
                        f.write(f"- **Response Snippet**: {resp_snippet}...\n")
                    f.write(f"- **Artifacts**: `{r['run_dir']}`\n\n")
                    
    print(json.dumps(report_data, indent=2))
    
    if failure_count > 0:
        sys.exit(1)

if __name__ == "__main__":
    main()
