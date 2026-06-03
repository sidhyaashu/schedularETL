import sys
import json
import requests
from datetime import datetime

# Paste your token and endpoint directly here
ACCORD_API_TOKEN = "Gp4r5wfgNYi72c0EdpWSf21oLLVjlwzr"
ACCORD_BASE_URL = "https://contentapi.accordwebservices.com/RawData/GetRawDataJSON"

class Tee:
    def __init__(self, filename):
        self.file = open(filename, "w", encoding="utf-8")
        self.stdout = sys.stdout

    def write(self, message):
        self.stdout.write(message)
        self.file.write(message)

    def flush(self):
        self.stdout.flush()
        self.file.flush()

    def close(self):
        self.file.close()

def fetch_and_analyze(date_ddmmyyyy: str):
    feed_name = "Resultsf_IND_Cons_Ex1"
    section = "Fundamental" # Default section for Resultsf
    
    log_filename = f"{feed_name}_{date_ddmmyyyy}_analysis.log"
    tee = Tee(log_filename)
    sys.stdout = tee
    
    try:
        print("=" * 60)
        print(f"FETCHING ACCORD FEED: {feed_name}")
        print(f"Target Date: {date_ddmmyyyy}")
        print(f"Base URL: {ACCORD_BASE_URL}")
        print("=" * 60)

        params = {
            "filename": feed_name,
            "date": date_ddmmyyyy,
            "section": section,
            "sub": "",
            "token": ACCORD_API_TOKEN,
        }

        response = requests.get(
            ACCORD_BASE_URL,
            params=params,
            timeout=60
        )
        
        print(f"HTTP Status Code: {response.status_code}")
        if response.status_code != 200:
            print(f"Error response body: {response.text[:1000]}")
            return

        raw_text = response.text
        raw_bytes_received = len(raw_text.encode('utf-8'))
        print(f"Total payload size: {raw_bytes_received / 1024:.2f} KB")

        print("\n--- Raw Response Preview (First 1000 characters) ---")
        preview = raw_text[:1000]
        print(preview + "..." if len(raw_text) > 1000 else preview)

        print("\nParsing JSON payload...")
        response_json = response.json()

        # Save the full raw JSON response to a file on disk
        json_filename = f"{feed_name}_{date_ddmmyyyy}.json"
        with open(json_filename, "w", encoding="utf-8") as f:
            json.dump(response_json, f, indent=2, default=str)
        print(f"Saved full JSON payload to file: {json_filename}")
        
        table = response_json.get("Table")
        if not table:
            print("Warning: 'Table' key not found in the response JSON!")
            print("Keys present in response:", list(response_json.keys()))
            return

        total_records = len(table)
        print(f"Total records in 'Table': {total_records}")

        # Flag breakdown analysis
        flag_counts = {}
        missing_flag_count = 0
        sample_record = None

        for record in table:
            if not sample_record:
                sample_record = record
                
            flag = record.get("Flag") or record.get("flag")
            if flag is not None:
                flag_str = str(flag).strip().upper()
                flag_counts[flag_str] = flag_counts.get(flag_str, 0) + 1
            else:
                missing_flag_count += 1

        print("\n--- Flag Breakdown ---")
        for flag_val, count in flag_counts.items():
            print(f"  Flag '{flag_val}': {count} records")
        if missing_flag_count > 0:
            print(f"  No flag present: {missing_flag_count} records")

        print("\n--- Sample Record Structure ---")
        if sample_record:
            print(json.dumps(sample_record, indent=2))
        else:
            print("No records available to display sample.")

        print(f"\nSaved full console output log to file: {log_filename}")

    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        # Restore normal stdout
        sys.stdout = tee.stdout
        tee.close()

if __name__ == "__main__":
    # Use command-line date argument (DDMMYYYY) or default to today's date
    target_date = sys.argv[1] if len(sys.argv) > 1 else datetime.now().strftime("%d%m%Y")
    fetch_and_analyze(target_date)
