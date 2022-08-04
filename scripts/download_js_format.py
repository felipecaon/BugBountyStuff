import requests
import os
import argparse
import jsbeautifier
import urllib3

# Disables SSL warnings
urllib3.disable_warnings()


def download_script(url, downloads_dir_path):
    """Download script into given directory. Note: Does nothing to avoid name collisions"""

    print(url)
    url_parse = requests.compat.urlparse(url)
    url_path = url_parse.hostname + url_parse.path
    local_filename = url_path.replace("/", "_")

    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36"
    }
    res = requests.get(url, headers=headers, verify=False)

    if res.status_code == 200:
        code = jsbeautifier.beautify(res.text)
        with open(os.path.join(downloads_dir_path, local_filename), "w+") as f:
            f.write(code)

        return local_filename


def ensure_dir(file_path):
    """Ensure directory exists by creating it if not present"""
    directory = os.path.dirname(file_path)
    if not os.path.exists(directory):
        os.makedirs(directory)


parser = argparse.ArgumentParser(
    description="Download all scripts from a website into a scripts/ folder underneath this script"
)
parser.add_argument(
    "list",
    metavar="LIST",
    type=str,
    help="List name containing the urls to download",
)
args = parser.parse_args()

downloads_dirname = "valid_scripts/"
curr_path = os.path.dirname(os.path.realpath(__file__))
downloads_path = os.path.join(curr_path, downloads_dirname)
ensure_dir(downloads_path)

file = open(args.list, "r")
lines = file.readlines()

for url in lines:
    if ".js" in url:
        print(f"Downloaded {download_script(url.strip(),downloads_path)}")
