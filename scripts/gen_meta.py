import json
import os
import sys

ipfs = {}


def gen_meta(meta_template, url, number):
    for i in range(number):
        meta_template['image'] = url
        meta_template['attributes'][2]['value'] = str(i)

        with open('meta/'+str(i)+'.json', 'w') as f:
            json.dump(meta_template, f, indent=4, ensure_ascii=False)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Uage: gen_meta.py [url] [number]")
        exit(0)

    if os.path.exists('meta.json'):
        with open('meta.json', 'r') as f:
            meta = json.load(f)
    else:
        print("meta.json not found, exit")
        exit(-1)

    if not os.path.exists('meta'):
        os.mkdir('meta')

    gen_meta(meta, sys.argv[1], int(sys.argv[2]))
