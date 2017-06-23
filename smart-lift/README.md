# iot-hackathon
Link to doc: https://docs.google.com/document/d/1LQoTMmO_xgyqk3XNUociiVUCoKDuTCVZRoyPxN7b25g

## How to start up frontend
`google-chrome --allow-file-access-from-files --enable-logging=stderr frontend/index.html 2>javascript.json`

Result will be in `javascript.json`. Then parse it with
```python
import re
result = re.split('PARSE:(.*)", sou', str)
if len(result) > 1:
    content = result[1]
```
where `str` is from stdin
