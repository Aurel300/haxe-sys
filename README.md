# **Work in progress!**

This is the working draft for the new `sys` package interfaces.

 - [Haxe Evolution proposal](https://github.com/HaxeFoundation/haxe-evolution/pull/59)

Current WIP is the HL implementation.

# Project structure

 - [`common-impl`](common-impl) - implementations common to all targets
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

## Running tests

```bash
cd tests
haxe build-hl.hxml
hl bin/test.hl
```
