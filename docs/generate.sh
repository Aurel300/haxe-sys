#!/bin/bash

haxe make.hxml && \
haxelib run dox \
    -ex ".*" \
    -in "^haxe\.async\." \
    -in "^haxe\.io\.Duplex" \
    -in "^haxe\.io\.FilePath" \
    -in "^haxe\.io\.IDuplex" \
    -in "^haxe\.io\.IReadable" \
    -in "^haxe\.io\.IWritable" \
    -in "^haxe\.io\.Readable" \
    -in "^haxe\.io\.ReadResult" \
    -in "^haxe\.io\.StreamTools" \
    -in "^haxe\.io\.Transform" \
    -in "^haxe\.io\.Writable" \
    -in "^haxe\.Error" \
    -in "^haxe\.ErrorType" \
    -in "^haxe\.NoData" \
    -in "^asys\." \
    -i docs-xml -o docs-html
