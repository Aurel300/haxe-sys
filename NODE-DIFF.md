# Detailed API differences

This is a complete list of differences between the new `sys` Haxe APIs and the original Node.js modules.

### Errors

[Node.js module](https://nodejs.org/api/errors.html)

 - **`haxe.Error`** - common base class for errors, corresponding to Node's [`Error` class](https://nodejs.org/api/errors.html#errors_class_error)
   - Haxe: `error.type` (`haxe.ErrorType` enum); Node: `error.code`

### Asynchrony

 - **`haxe.async.Callback`** - abstract over any error-first callback (error being of type `haxe.Error`) (Node: `<Function>`)
 - **`haxe.async.Event`** - Node event system is quite different (but also type-unsafe); in Haxe any event on a class is declared as `final eventXyz:Event<EventData>`, corresponding to Node event `xyz` which calls the listener with an `EventData` argument
   - if the event has no data associated with it, it is declared with type `Event<NoData>` in Haxe (Node: calls the listener with no arguments)
   - if the event has more than one field associated with it, it is declared with type `Event<{field1:Type1, ...}>` (Node: calls the listener with multiple arguments)
 - **`haxe.async.Listener`** - an event listener (Node: `<Function>`)

The difference between `Callback` and `Listener` is that `Callback<T>` takes an error as the first argument *in addition to* its data (of type `T`), `Listener<T>` only takes the data of type `T`.

### Flags, modes, constants

Several methods in the API accept constants or a combination of flags. Constants (where the argument is *exactly one of* a set of options) have been converted to an `enum` or `enum abstract`:

 - **`sys.FileOpenFlags`**
 - **`sys.net.Net.IPFamily`**
   - `IPv4` (Node: `4`)
   - `IPv6` (Node: `6`)
 - **`sys.net.Net.NetFamily`**

Flags (where the argument is *zero or more of* a set of options) have been converted to an `abstract` over `Int`, with an overloaded `|` operator:

 - **`sys.FileAccessMode`**
 - **`sys.FileCopyFlags`**
   - `FailIfExists` (Node: `fs.constants.COPYFILE_EXCL`)
   - `COWClone` (Node: `fs.constants.COPYFILE_FICLONE`)
   - `COWCloneForce` (Node: `fs.constants.COPYFILE_FICLONE_FORCE`)
 - **`sys.FileMode`**
 - **`sys.net.Dns.DnsHints`**
   - `AddrConfig` (Node: `dns.ADDRCONFIG`)
   - `V4Mapped` (Node: `dns.V4MAPPED`)

All of the above are additionally mentioned near the method that uses them.

### Encoding and paths

Node methods which take an `encoding` argument and decide their return type based on its value have been changed:

 - if the return value represents a file path, it is always a `String` (see [proposal](README.md#non-unicode-filepaths))
 - if the return value represents data, it is always of type `Bytes`

Additionally, Node methods generally accept `<string>` | `<Buffer>` | `<URL>` for any path argument. These have been changed to `String` only.

### File descriptors

Node methods which accept `fd` in an `options` argument have either been removed or adapted to accepting classes (`sys.io.File`, `sys.async.net.Socket`, `sys.net.Server`). See [proposal](https://github.com/Aurel300/haxe-sys/blob/master/README.md#file-descriptors).

### Dns

[Node.js module](https://nodejs.org/api/dns.html)

 - **`sys.net.Dns`** (Node: `dns` module)
   - `lookup`
     - Haxe: `options` type extracted into a typedef `sys.net.Dns.DnsLookupOptions`
   - `sys.net.Dns.DnsLookupOptions`
     - `family` - Haxe: enum type `sys.net.Net.IPFamily` (see [flags](#flags-modes-constants))
     - `hints` - Haxe: abstract type `sys.net.Dns.DnsHints` (see [flags](#flags-modes-constants))
   - `resolve*` (`resolve`, `resolve4`, `resolve6`, `resolveAny`, `resolveCname`, `resolveMx`, `resolveNaptr`, `resolveNs`, `resolvePtr`, `resolveSoa`, `resolveSrv`, `resolveTxt`)
     - Haxe: all callbacks have the same type, `Callback<sys.net.Dns.DnsRecord>`, which is an `enum` which also stores the data relevant to each DNS record type
     - Node: callbacks have different types in different `resolve` functions
   - `resolve4`, `resolve6`
     - Haxe: `?ttl:Bool` as an optional argument
     - Node: `?options:{ttl:Bool}` as an optional argument
 - **`sys.net.Dns.DnsResolver`** (Node: `dns.Resolver`)
   - (`resolve*` comments from `sys.net.Dns` also apply here)
 - **`sys.net.Dns.DnsRecord`** (Node: `<string>`, `<string[]>`, or `<Object>`)

### Fs

[Node.js module](https://nodejs.org/api/fs.html)

 - **`sys.DirectoryEntry`** (Node: `Dirent`)
 - **`sys.FileWatcher`** (Node: `FSWatcher`)
   - `eventChange:Event<FileWatcherEvent>`
     - Haxe: `FileWatcherEvent` is an `enum` with `Rename(path)` and `Change(path)` cases
     - Node: the event has a `type:String` and a `filename`
 - **`sys.FileWatcher.FileWatcherEvent`**
 - **`sys.FileStat`** (Node: `Stats`)
   - Haxe: abstract over `sys.FileStat.FileStatData` to provide the `isXyz` functions
 - **`sys.async.FileSystem`** - asynchronous (callback) methods (Node: `fs` module)
   - `access`
     - `mode` - Haxe: enum type `sys.FileAccessMode` (see [flags](#flags-modes-constants))
   - `appendFile`
     - Haxe: `flags` - enum type `sys.FileOpenFlags` (see [flags](#flags-modes-constants))
     - Haxe: `mode` - enum type `sys.FileAccessMode` (see [flags](#flags-modes-constants))
     - Node: `options:{encoding, mode, flag}`
   - `chmod`
     - `mode` - Haxe: enum type `sys.FileMode` (see [flags](#flags-modes-constants))
     - **added** Haxe: `followSymlinks` - replaces `lchmod`
   - `chown`
     - **added** Haxe: `followSymlinks` - replaces `lchown`
   - **removed** Node: `close` - replaced by `sys.io.File.close()`
   - **removed** Node: `constants` - replaced by various enum and abstract types (see [flags](#flags-modes-constants))
   - `copyFile`
     - `flags` - Haxe: enum type `sys.FileCopyFlags` (see [flags](#flags-modes-constants))
   - `createReadStream`
     - `options.flags` - Haxe: enum type `sys.FileOpenFlags` (see [flags](#flags-modes-constants))
   - `createWriteStream`
     - `options.flags` - Haxe: enum type `sys.FileOpenFlags` (see [flags](#flags-modes-constants))
   - `exists`
     - `callback` - Haxe: changed to standard error-first callback (reason for deprecation in Node was that the callback was not consistent with other APIs)
   - **removed** Node: `fchmod`, `fchown`, `fdatasync`, `fstat`, `fsync`, `ftruncate`, `futimes` - these methods all take a `fd` - replaced by methods in `sys.io.File`
   - **removed** Node: `lchmod`, `lchown`, `lstat` - replaced by `followSymlinks` on `chmod`, `chown`, `stat`
   - `mkdir`
     - Haxe: `recursive`
     - Haxe: `mode` - enum type `sys.FileAccessMode` (see [flags](#flags-modes-constants))
     - Node: `options:{recursive, mode}`
   - `open`
     - `flags` - Haxe: enum type `sys.FileOpenFlags` (see [flags](#flags-modes-constants))
     - `mode` - Haxe: enum type `sys.FileMode` (see [flags](#flags-modes-constants))
   - **removed** Node: `read` - replaced by `sys.io.File.read`
   - `readdir`
     - Haxe: `readdir` returns `Array<String>`
     - Haxe: `readdirTypes` returns `Array<DirectoryEntry>` 
     - Node: `readdir` returns either depending on `options.withFileTypes`
   - `readFile`
     - Haxe: `flags` - enum type `sys.FileOpenFlags` (see [flags](#flags-modes-constants))
     - Node: `options:{flags}`
   - **removed** Node: `realpath.native`
   - `stat`
     - **added** Haxe: `followSymlinks` - replaces `lstat`
     - **removed** Node: `options:{bigint}`
   - `utimes`
     - Haxe: `atime`, `mtime` are of type `Date`
     - Node: `atime`, `dtime` can be `<number>`, `<string>`, or `<Date>`
   - **removed** Node: `write` - replaced by `sys.io.File.write`
   - `writeFile`
     - Haxe: `flags` - enum type `sys.FileOpenFlags` (see [flags](#flags-modes-constants))
     - Haxe: `mode` - enum type `sys.FileMode` (see [flags](#flags-modes-constants))
     - Node: `options:{encoding, mode, flag}`
 - **`sys.FileSystem`** - synchronous methods (Node: `fs` module)
   - all `Sync` suffixes were removed, since all methods in this class are synchronous
   - all notes from `sys.async.FileSystem` apply here as well
   - **removed** Node: `unwatchFile`, `watchFile` - possible via `watch`

### Net

[Node.js module](https://nodejs.org/api/net.html)

 - **`sys.async.net.Socket`** (Node: `Socket`)
   - constructor
     - Haxe: `options` type extracted into a typedef `sys.async.net.Socket.SocketOptions`
   - `eventClose`
     - Haxe: inherited from `haxe.io.Duplex`, so it has no data
       - **added** Haxe: `var hadError:Bool` to `Socket` class
     - Node: `Socket` event has an additional field `hadError`
   - `address`
     - Haxe: returns `sys.net.Net.SocketAddress`
     - Node: returns `{port:Int, family:String, address:String}`
   - `connect`
     - Haxe: `options` type extracted into a typedef `sys.async.net.Socket.SocketConnectOptions`
     - **renamed** overload with `path` to `connectIPC`
     - **renamed** overload with `port`, `host` to `connectTCP`
 - **`sys.async.net.Socket.SocketOptions`** (Node: `<Object>`)
 - **`sys.async.net.Socket.SocketConnectOptions`** (Node: `<Object>`)
   - `family` - Haxe: `sys.net.Net.IPFamily` (see [flags](#flags-modes-constants))
   - `hints` - Haxe: `sys.net.Dns.DnsHints` (see [flags](#flags-modes-constants))
 - **`sys.async.net.Socket.SocketCreationOptions`** (Node: `<Object>`) - typedef merging `SocketOptions` and `SocketCreationOptions`
 - **`sys.net.Net.SocketAddress`** (Node: `{port:Int, family:String, address:String}` or `<string>`)
 - **`sys.net.Server`** (Node: `Server`)
   - `address`
     - Haxe: returns `sys.net.Net.SocketAddress`
     - Node: returns `{port:Int, family:String, address:String}` or `string`
   - **removed** Node: `connections` - deprecated
   - `listen`
     - **removed** Node: overload with `options`
     - listening on a file descriptor
       - **added** Haxe: `listenSocket`
       - **added** Haxe: `listenServer`
       - **added** Haxe: `listenFile`
       - **removed** Node: overload with `handle`
     - listening on path
       - **added** Haxe: `listenIPC`
       - **removed** Node: overload with `path`
     - listening on TCP
       - **added** Haxe: `listenTCP`
       - **removed** Node: overload with `port`, `host`
 - **`sys.net.Net`** (Node: `net` module)
   - `isIP`
     - Haxe: returns `Null<IPFamily>` - `null` if input is not an IP, `IPv4` or `IPv6` if it is
     - Node: returns `<integer>` - `0` if input is not an IP, `4` or `6` if it is
   - **removed** Node: `connect` - alias to `createConnection`
   - `createConnection`
     - **removed** Node: overload with `path` - possible using the `options` alternative or using `sys.async.net.Socket` directly
     - **removed** Node: overload with `port`, `host` - possible using the `options` alternative or using `sys.async.net.Socket` directly

### Path

[Node.js module](https://nodejs.org/api/path.html)

 - **haxe.io.Path** (Node: `path` module)
   - `join`, `resolve`
     - Haxe: `paths:Array<String>`
     - Node: `...paths`
   - `posix`, `win32`
     - Haxe: instances of `haxe.io.Path.PathPosix` and `haxe.io.Path.PathWin32` objects
     - Node: circular references to the module itself or an alternative API

### Streams

[Node.js module](https://nodejs.org/api/streams.html)

 - **removed** Node: chained returns - due to typing issues
   - Haxe: `Stream.destroy`, `Readable.pipe`, `Readable.resume`, `Readable.unpipe` return `Void`
   - Node: the methods return `<this>`
 - **removed** Node: object mode streams
 - encoding
   - **removed** Node: `setDefaultEncoding`
   - **removed** Node: `setEncoding`
 - **`haxe.io.Duplex`** (Node: `Duplex`)
 - **`haxe.io.IReadable`** (Node: `Readable` interface)
   - `readableFlowing`
     - Haxe: type `haxe.io.ReadableState`
     - Node: type `<boolean>` or `<null>`
   - `pipe`
     - Haxe: `end:?Boolean`
     - Node: `?options:{end}`
   - **removed** Node: `wrap` - method exists for compatibility with old Node APIs
   - **removed** Node: `asyncIterator` - requires coroutines
 - **`haxe.io.IStream`**
 - **`haxe.io.IWritable`** (Node: `Writable` interface)
 - **`haxe.io.Readable`** (Node: `Readable`)
 - **`haxe.io.Stream`** (Node: `Stream` instances)
   - `pipeline`
     - Haxe: `streams:Array<IStream>`
     - Node: `...streams`
 - **`haxe.io.Writable`** (Node: `Writable`)

### UDP

[Node.js module](https://nodejs.org/api/dgram.html)

 - **`sys.net.UdpSocket`** (Node: `UdpSocket` and `dgram` module)
   - `eventMessage:Event<sys.net.Udp.UdpMessage>`
     - `family` - Haxe: `sys.net.Net.IPFamily` (see [flags](#flags-modes-constants))
   - `address`, `remoteAddress`
     - Haxe: returns `sys.net.Net.SocketAddress`
     - Node: returns `{port:Int, family:String, address:String}` or `string`
   - `bind`
     - **removed** Node: overload with `options`
   - `createSocket`
     - **removed** Node: overload with `type` - moved `type` out of `options.type` as a required argument

### Url

[Node.js module](https://nodejs.org/api/url.html)

 - **`sys.net.Url`** (Node: `URL`)
   - `port`
     - Haxe: `port:Null<Int>` becomes `null` when the default port of a given protocol is used
     - Node: `port:String` becomes the empty string when the default port of a given protocol is used
   - **removed** Node: `toJSON` - this is a magic method which is not used in Haxe, it is also equivalent to `toString`
   - `format`
     - Haxe: `options` type extracted into a typedef `sys.net.Url.UrlFormatOptions`
 - **`sys.net.Url.UrlSearchParams`** (Node: `URLSearchParams`)
   - constructor, from string
     - Haxe: `UrlSearchParams.fromString(str:String)`
     - Node: `new UrlSearchParams(str)`
   - constructor, from object
     - Haxe: `UrlSearchParams.fromMap(map:Map<String, Array<String>>)` - all values must be arrays of strings
     - Node: `new UrlSearchParams(obj)` - `obj` is an object; values can be either strings or arrays of strings
   - constructor, from iterable
     - Haxe: `UrlSearchParams.fromIterable(iterable:KeyValueIterable<String, String>)`
     - Node: `new UrlSearchParams(iterable)`
   - iteration
     - **added** Haxe: `function iterator`
     - **added** Haxe: `function keyValueIterator`
     - **removed** Node: `function entries`
     - **removed** Node: `function forEach`
     - **removed** Node: `function keys`
     - **removed** Node: `function values`
