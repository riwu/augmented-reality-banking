# iot-hackathon
Link to doc: https://docs.google.com/document/d/1LQoTMmO_xgyqk3XNUociiVUCoKDuTCVZRoyPxN7b25g

## How to start up frontend
`google-chrome --allow-file-access-from-files --enable-logging=stderr frontend/index.html 2>&1 | grep 'PARSE' --color=never | sed -e 's/.*PARSE:\(.*\)", sou.*/\1/g'`

Result will be out in stdout. Then parse it with
```python
import re
re.split('PARSE:(.*)", sou', str)[1]
```
where `str` is from stdin
