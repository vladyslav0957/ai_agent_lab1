#!/usr/bin/env bash
set -e

npm install
npm run build
test -f dist/hello.js
npm test
