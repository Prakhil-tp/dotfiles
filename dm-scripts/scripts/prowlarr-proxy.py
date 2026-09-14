#!/usr/bin/env python3
import json, urllib.request, urllib.error
from http.server import HTTPServer, BaseHTTPRequestHandler
import re

PROWLARR = "http://127.0.0.1:9696"

class Proxy(BaseHTTPRequestHandler):
    def do_GET(self):
        url = PROWLARR + self.path
        try:
            headers = {}
            for key, value in self.headers.items():
                if key.lower() in ("host", "content-length", "connection", "accept-encoding"):
                    continue
                headers[key] = value
            req = urllib.request.Request(url, headers=headers)
            with urllib.request.urlopen(req, timeout=120) as resp:
                data = resp.read()
                ct = resp.headers.get("Content-Type", "")
                if "/api/v1/search" in self.path and "json" in ct:
                    results = json.loads(data)
                    for r in results:
                        if "downloadUrl" not in r:
                            r["downloadUrl"] = r.get("guid", "")
                    data = json.dumps(results).encode()
                self.send_response(200)
                self.send_header("Content-Type", ct or "application/json")
                self.send_header("Content-Length", str(len(data)))
                self.end_headers()
                self.wfile.write(data)
        except urllib.error.HTTPError as e:
            self.send_response(e.code)
            self.end_headers()
            self.wfile.write(e.read())
        except Exception as e:
            self.send_response(502)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps({"error": str(e)}).encode())

HTTPServer(("127.0.0.1", 9697), Proxy).serve_forever()
