# New filesystem API

* Proposal: [HXP-NNNN](NNNN-filename.md)
* Author: [Aurel Bílý](https://github.com/Aurel300)

## Introduction

Improved API for filesystem operations based on Node.js; includes asynchronous alternatives with callbacks.

## Motivation

The current filesystem APIs in Haxe lack a number of features commonly found in other APIs, such as Node.js. Some examples include:

 - changing permissions, owners of files
 - symlink operations
 - watching for changes

More importantly, there is no way to asynchronously perform a filesystem operation without creating a `Thread` to execute the task.

## Detailed design

Modified modules:

 - [`haxe.io.Path`](haxe/io/Path.hx)
 - [`sys.FileStat`](sys/FileStat.hx)
 - [`sys.FileSystem`](sys/FileSystem.hx)
 - [`sys.io.File`](sys/io/File.hx)

Added modules:

 - [`haxe.Error`](haxe/Error.hx)
 - [`sys.FileAccessMode`](sys/FileAccessMode.hx)
 - [`sys.FileCopyFlags`](sys/FileCopyFlags.hx)
 - [`sys.FileMode`](sys/FileMode.hx)
 - [`sys.FileOpenFlags`](sys/FileOpenFlags.hx)
 - [`sys.FileWatcher`](sys/FileWatcher.hx)
 - [`sys.async.FileSystem`](sys/async/FileSystem.hx)
 - [`sys.io.AsyncFile`](sys/io/AsyncFile.hx)

### Errors

A `haxe.Error` class is added to unify error reporting in the system APIs. It has a `message` field which contains the human-readable description of the error. It also includes a `type` field which can be `switch`-ed on.

```haxe
try {
  sys.FileSystem.someOperation();
} catch (err:haxe.Error) {
  trace("error!", err);
}
// or
try {
  sys.FileSystem.someOperation();
} catch (err:haxe.Error) {
  switch (err.type) {
    case FileNotFound: // it's fine
    case _: throw err;
  }
}
```

> **Unresolved question:**
> 
> There are multiple ways of expressing proper type-safe errors for the filesystem API:
> - errors represented by a single `enum` (`sys.FileSystemError`), with the individual cases containing all the information of that particular error
>   - awkward to catch individual errors (any `catch` would need a `switch`)
>   - fewer classes to maintain, less work to throw errors (the case names the error, so no message is needed)
> - errors represented by sub-classes of a single base class
>   - possible to catch individual subclasses in separate `catch` blocks
>   - many classes in the package (could be moved into a sub-package for errors?)
> - base class `Error` + enum for types, as implemented in the draft now
> 
> The primary aim for any solution is to be able to catch specific types of errors without having to rely on string comparison.

### Callbacks

Asynchronous methods are identical to their synchronous counter-parts, except:

 - their return type is `Void`
 - they have an additional, required `callback` argument
   - first argument passed to the callback is a `haxe.Error`, or `null` if no error occurred
   - any additional arguments represent the data returned by the call, analogous to the return type of the synchronous method; if the synchronous method has a `Void` return type, the callback takes no additional arguments

### File descriptors

The Node.js API has a concept of file descriptors, represented by a single integer. To avoid issues with platforms without explicit file descriptor numbers, `sys.io.File` is an `abstract`, similar to the new threading API.

Various `fs.f*` methods from Node.js which take `fd` as their first argument are moved into their own methods in the `File` abstract.

### Synchronous / asynchronous versions

To avoid the `someMethod` + `someMethodSync` naming scheme present in Node.js, the two versions are more clearly split:

 - `sys.FileSystem` and `sys.async.FileSystem` (static methods)
 - `sys.io.File` has an `async` filed for asynchronous instance methods

```haxe
// synchronously:
var file = sys.FileSystem.open("file.txt", Read);
var data = file.readFile();

// asynchronously:
sys.async.FileSystem.open("file.txt", Read, (err, file) -> {
    file.readFile((err, data) -> {
        // ...
      });
  });
```

### Non-Unicode filepaths

In Node.js, wherever a path is expected as an argument, a `Buffer` can be provided, equivalent to `haxe.io.Bytes`. Similarly, whenever paths are to be returned, either a `String` or a `Buffer` is returned, depending on the `encoding` option (`"utf8"` or `"buffer"`).

It would be awkward to mirror this behaviour in Haxe, so instead, the assumption is made that filepaths will be Unicode most of the time, and `String` is used consistently in the API. In the rare cases that non-Unicode paths are returned, they are escaped into a Unicode string. The original `Bytes` can be obtained with `sys.FileSystem.bytesOfPath(path)`. There is also the inverse `sys.FileSystem.pathOfBytes(bytes)`.

See https://github.com/HaxeFoundation/haxe/issues/8134

### Backward compatibility

The methods in the current `sys.FileSystem` and `sys.io.File` APIs will be kept for the time being, as `inline`s using the new methods. The names of the methods in Node.js are arguably less intuitive (e.g. `mkdir` instead of `createDirectory`), but they were kept to retain familiarity.

### Target specifics

Where possible, the asynchronous methods should use native calls. For some targets this might not be possible, so in the worst-case scenario these methods will run the synchronous call in a `Thread`, then trigger the callback once done.

(**TODO:** research individual APIs for most targets)

 - cpp
 - cs
 - eval
 - hl
 - java
 - js (with `hxnodejs`) - mostly trivial mapping since it is the Node.js API
 - lua
 - neko
 - php
 - python

### Testing

The majority of tests for the current `sys` classes should be reused. It may be worthwhile to adapt the existing tests to test both implementations (with a forced synchronous operation on `sys.async`) so tests are not duplicated. Additional tests should be written to test async-specific features, such as writing multiple files in parallel.

For methods that were not present in the original APIs, some tests may be based on the extensive [Node.js test suite](https://github.com/nodejs/node/tree/master/test/parallel).

## Impact on existing code

Existing code should not be affected, since the new classes will have methods for backward compatibility.

## Drawbacks

-

## Alternatives

-

## Opening possibilities

-

## Unresolved questions

 - [error reporting](#errors)
 - currently all filesize and file position arguments are `Int`, but this only allows sizes of up to 2 GiB
   - should we use `haxe.Int64`?
   - is the support of `haxe.Int64` good enough on sys targets
   - Node.js uses the `Number` type, which has at least 53 bits of integer precision
