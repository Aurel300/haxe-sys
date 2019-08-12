#!/bin/bash

haxe make.hxml && \
haxelib run dox -ex ".*" \
    -in "^haxe\.async\." \
    -in "^haxe\.io\.Duplex" \
    -in "^haxe\.io\.FilePath" \
    -in "^haxe\.io\.IDuplex" \
    -in "^haxe\.io\.IReadable" \
    -in "^haxe\.io\.IWritable" \
    -in "^haxe\.io\.Readable" \
    -in "^haxe\.io\.StreamTools" \
    -in "^haxe\.io\.Transform" \
    -in "^haxe\.io\.Writable" \
    -in "^haxe\.Error" \
    -in "^haxe\.ErrorType" \
    -in "^haxe\.NoData" \
    -in "^nusys\." \
    -in "^sys\.net\.DnsLookupOptions" \
    -in "^sys\.net\.IpFamily" \
    -in "^sys\.net\.UdpSocket" \
    -in "^sys\.uv\." \
    -in "^sys\.DirectoryEntry" \
    -in "^sys\.FileAccessMode" \
    -in "^sys\.FileOpenFlags" \
    -in "^sys\.FilePermissions" \
    -in "^sys\.FileWatcher" \
    -in "^sys\.FileWatcherEvent" \
    -in "^sys\.Net" \
    -in "^sys\.SymlinkType" \
    -i docs-xml -o docs-html
