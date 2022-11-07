import os
import sys
from dotenv import load_dotenv
from mcs.upload.mcs_upload import MCSUpload
import json
from datetime import datetime

if __name__ == "__main__":
    logs = {}
    log_file = os.getenv("HOME")+'/.ipfs_update_log.json'
    env_file = os.getenv("HOME")+"/.env_ipfs"

    if os.path.exists(log_file):
        with open(log_file, 'r') as f:
            logs = json.load(f)

    if not os.path.exists(env_file):
        print("need env file at $(HOME) directory")
        exit(-1)

    load_dotenv(env_file)
    wallet_address = os.getenv('wallet_address')
    private_key = os.getenv('private_key')
    rpc_endpoint = os.getenv('rpc_endpoint')

    if len(sys.argv) < 2:
        print("Usage: p ipfs_upload.py [file]")
        exit(-1)
    filepath = os.path.abspath(sys.argv[1])

    print(f"uploading {filepath} to IPFS...")
    up = MCSUpload("polygon.mainnet", wallet_address,
                   private_key, rpc_endpoint, filepath)

    file_data, need_pay = up.stream_upload()

    if up.upload_response['status'] != 'Free':
        print("No enough free storage")
        exit(-1)

    _id = up.upload_response['payload_cid']
    logs[_id] = {}

    logs[_id]['file'] = filepath
    for key in list(up.upload_response.keys()):
        if key == 'status' or key == 'payload_cid':
            continue
        logs[_id][key] = up.upload_response[key]
    logs[_id]['upload_time'] = datetime.now().strftime("%d/%m/%Y %H:%M:%S")

    with open(log_file, 'w') as f:
        json.dump(logs, f, indent=4, ensure_ascii=False)

    print(
        f"\n{filepath} uploaded at:\n{up.upload_response['ipfs_url']}\nlog stored in {log_file}")
