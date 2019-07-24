# **Work in progress!**

This is the working draft for the new `sys` package interfaces.

 - [Haxe Evolution proposal](https://github.com/HaxeFoundation/haxe-evolution/pull/59)

Current WIP is the eval implementation.

# Status

## Target TODO

| Target | Build | Binds | FS | T | Net | T | Note |
| ------ | ----- | ----- | -- | - | --- | - | ---- |
| hl     | Y     | Y     | Y  | . |     |   | [ffi](https://github.com/Aurel300/hashlink/tree/feature/libuv), [impl](hl-impl) |
| eval   | Y     | .     | .  |   |     |   | [ffi](https://github.com/Aurel300/haxe/tree/feature/eval-libuv/libs/uv), [impl](https://github.com/Aurel300/haxe/blob/feature/eval-libuv/src/macro/eval/evalString.ml) |
| cpp    |       |       |    |   |     |   |      |
| js     | n/a   | n/a   |    |   |     |   | hxnodejs only, most APIs forwarded directly |
| rest   | n/a   |       |    |   |     |   |      |

 - "Build" - can we compile the interpreter (if any) with libuv?
 - "Binds" - is the FFI finished, or is there a good binding library available?
 - "FS" - are the filesystem functions implemented?
 - "Net" - are the networking (TCP, UDP, DNS) functions implemented?
 - "T" - are the tests for the previous column done?
 - "Y", ".", " ", "n/a" - yes, partially, no, not applicable

 - [ ] hl, eval, cpp - use GC a bit better; automatically close `uv_file` (and others?) once collected
 - [ ] eval - figure out instance variables (`final` in particular) on eval types, would allow unifying e.g. `sys.uv.Stat`

## Common TODO

These should be implementable in pure Haxe.

 - [ ] streams - based on `streams3` of Node.js
 - [ ] HTTP - built on top of raw sockets

## Per function notes

| Category | Function | Notes |
| -------- | -------- | ----- |
| FS | `copyfile` | n/a; only in libuv >= 1.14 |
| FS | `chmod` with `followSymlinks == false` | n/a; `lchmod` only in libuv >= 1.21 |
| FS | `chown` with `followSymlinks == false` | n/a; `lchown` only in libuv >= 1.21 |
| FS | `truncate` | emulated with `open("r+")`, `ftruncate` (see [node](https://github.com/nodejs/node/blob/e71a0f4d5faa4ad77887fbb3fff0ddb7bca6942e/lib/fs.js#L638-L657)) |
| FS | `mkdir` with `recursive == true` | emulated |
| FS | `rmdir` | ??? should we have a `recursive` mode for `rmdir` |
| loop | `run` | implement `haxe.Timer` with UV? tick UV in RunOnce mode only? |

# Project structure

 - [`common-impl`](common-impl) - implementations common to all targets
 - [`eval-impl`](eval-impl) - externs for eval
 - [`hl-impl`](hl-impl) - implementations for HashLink
 - [`sys`](sys) - not-yet-implemented externs for all targets
 - [`tests`](tests) - unit tests

Note that `nusys` is used as a temporary package for the classes that will eventually become `sys`.

# Testing

## HashLink setup

To test the HashLink implementations, please use the [`feature/libuv`](https://github.com/Aurel300/hashlink/tree/feature/libuv) branch of Aurel300/hashlink, which includes updated libuv FFI.

```bash
git clone git@github.com:Aurel300/hashlink.git
cd hashlink
make
make install
```

## Eval setup

To test the Eval implementations, please use the [`feature/eval-libuv`](https://github.com/Aurel300/haxe/tree/feature/eval-libuv) branch of Aurel300/haxe, which includes libuv FFI and OCaml implementations.

## Running tests

```bash
cd tests
haxe build-hl.hxml && hl bin/test.hl
haxe build-eval.hxml
```
