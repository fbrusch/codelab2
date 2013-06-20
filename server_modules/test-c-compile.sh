#!/bin/sh

curl -v -H "Accept: application/json" \
        -H "Content-type: application/json" \
        -X POST \
        -d ' {"code": "int a;"}' \
        http://localhost:4444/emscripten