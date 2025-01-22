### 3. **`api_hunter.py` Script (No changes needed)**

```python
import os
import subprocess
import argparse
import builtwith
import requests

def run_apihunter(target_url, depth, output_dir):
    print(f"[*] Running APIHunter for target: {target_url} with depth {depth}")
    try:
        subprocess.run(["python3", "APIHunter/apihunter.py", target_url, "--depth", str(depth), "--output", output_dir], check=True)
    except subprocess.CalledProcessError as e:
        print(f"[ERROR] Failed to run APIHunter: {e}")
        return False
    return True

def run_jsfinder(target_url):
    print(f"[*] Running JSFinder for target: {target_url}")
    try:
        subprocess.run(["python3", "JSFinder/jsfinder.py", target_url], check=True)
    except subprocess.CalledProcessError as e:
        print(f"[ERROR] Failed to run JSFinder: {e}")
        return False
    return True

def run_katana(target_url):
    print(f"[*] Running Katana for target: {target_url}")
    try:
        subprocess.run(["./katana", "-u", target_url, "--depth", "10", "--no-subdomains"], check=True)
    except subprocess.CalledProcessError as e:
        print(f"[ERROR] Failed to run Katana: {e}")
        return False
    return True

def main(target_url, depth, output_dir):
    # Run APIHunter
    if not run_apihunter(target_url, depth, output_dir):
        return

    # Run JSFinder
    if not run_jsfinder(target_url):
        return

    # Run Katana
    if not run_katana(target_url):
        return

    print(f"[*] Finished API enumeration for {target_url}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="API Finder")
    parser.add_argument("-u", "--url", required=True, help="Target URL")
    parser.add_argument("-d", "--depth", type=int, default=100, help="Depth for APIHunter")
    parser.add_argument("-o", "--output", required=True, help="Output directory for results")
    
    args = parser.parse_args()

    main(args.url, args.depth, args.output)
