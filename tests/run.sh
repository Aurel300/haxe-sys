#!/bin/bash

echo "testing hl ..."
haxe build-hl.hxml && hl bin/test.hl

echo "testing eval ..."
haxe build-eval.hxml
