# **Work in progress!**

This is the working draft for the new `sys` package APIs.

 - [Haxe Evolution proposal](https://github.com/HaxeFoundation/haxe-evolution/pull/59)
 - [API documentation](https://media.thenet.sk/haxe-sys/)

---

 - [Major features](#major-features)
 - [Status](#status)
   - [Target TODO](#target-todo)
   - [Common TODO](#common-todo)
   - [Per function notes](#per-function-notes)
 - [Project structure](#project-structure)
   - [Documentation](#documentation)
 - [Testing](#testing)
   - [HashLink setup](#hashlink-setup)
   - [Eval setup](#eval-setup)
   - [Running tests](#running-tests)

# Major features

 - asynchrony
 - more filesystem operations
 - networking
   - DNS
   - TCP
   - UDP
   - Unix/IPC
 - processes
   - pipes
   - message passing (via extended `Serializer`)
 - streams
   - (TODO) wrap stdin, stdout, stderr in streams

# Status

**Current WIP is the eval implementation.** HL will remain broken until eval is feature-complete.

## Target TODO

| Target | Build | Binds | FS | T | Net | T | Prc | T | Note |
| ------ |:-----:|:-----:|:--:|:-:|:---:|:-:|:---:|:-:| ---- |
| eval   | Y     | P     | P  | P | P   | P | P   | P | [ffi](https://github.com/Aurel300/haxe/tree/feature/eval-libuv/libs/uv), [impl](https://github.com/Aurel300/haxe/blob/feature/eval-libuv/src/macro/eval/evalStdLib.ml), [externs](eval-impl) |
| hl     | Y     | Y     | Y  | P | N   | N | N   | N | [ffi](https://github.com/Aurel300/hashlink/tree/feature/libuv), [impl](hl-impl) |
| cpp    | N     | N     | N  | N | N   | N | N   | N |      |
| js     | -     | -     | N  | N | N   | N | N   | N | hxnodejs only, most APIs forwarded directly |
| rest   | -     | N     | N  | N | N   | N | N   | N |      |

 - `Build` - can we compile the interpreter (if any) with libuv?
 - `Binds` - is the FFI finished, or is there a good binding library available?
 - `FS` - are the filesystem functions implemented?
 - `Net` - are the networking (TCP, UDP, DNS) functions implemented?
 - `Prc` - are the process functions implemented?
 - `T` - are the tests for the previous column done?
 - `Y`, `P`, `N`, `-` - yes, partially, no, not applicable

 - [ ] hl, eval, cpp - use GC a bit better; automatically close `uv_file` (and others?) once collected
 - [ ] eval - figure out instance variables (`final` in particular) on eval types, would allow unifying e.g. `sys.uv.Stat`

## Common TODO

These should be implemented in pure Haxe, with minimal `#if <target>` parts where necessary.

| Feature | Impl   | T | Notes |
| ------- | ------ |:-:| ----- |
| streams | P      | P | based on `streams3` of Node.js; simplified interface (dropped legacy APIs) |

 - [ ] stream auto-HWM balancing, piping
 - [ ] cleanup packages (move `nusys` to `sys2` and drop some of the `async` sub-packaging?)

## Per function notes

| Category | Function | Notes |
| -------- | -------- | ----- |
| FS | `copyfile` | n/a; only in libuv >= 1.14 |
| FS | `chmod` with `followSymlinks == false` | n/a; `lchmod` only in libuv >= 1.21 |
| FS | `chown` with `followSymlinks == false` | n/a; `lchown` only in libuv >= 1.21 |
| FS | `truncate` | emulated with `open("r+")`, `ftruncate` (see [node](https://github.com/nodejs/node/blob/e71a0f4d5faa4ad77887fbb3fff0ddb7bca6942e/lib/fs.js#L638-L657)) |
| FS | `mkdir` with `recursive == true` | emulated |
| FS | `rmdir` | ??? should we have a `recursive` mode for `rmdir` |

# Project structure

 - implementations
   - [`common-impl`](common-impl) - implementations common to all targets
   - [`eval-impl`](eval-impl) - externs for eval
   - [`hl-impl`](hl-impl) - implementations for HashLink
 - documentation
   - [`docs`](docs)
 - tests
   - [`tests`](tests) - unit tests

Note that `nusys` is used as a temporary package for the classes that will eventually become `sys`. This allows the tests to rely on old APIs for verifying the behaviour of the new ones.

The classes in `<target>-impl` are expected to shadow those in `common-impl`, just like the existing standard library in Haxe.

Once the new APIs are ready to be merged into the standard library:

 - `common-impl` will be added to `std`
 - for each `<target>`
   - `<target>-impl/<target>` will be added to `std/<target>`
   - all other directories in `<target>-impl` will be added to `std/<target>/_std`

## Documentation

A build of the documentation is available [here](https://media.thenet.sk/haxe-sys/). It can be built manually using the [`docs/generate.sh`](docs/generate.sh) script.

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
