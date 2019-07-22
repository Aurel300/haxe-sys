package sys;

import haxe.Error;
import haxe.io.Bytes;
import haxe.io.FilePath;
import sys.io.FileReadStream;
import sys.io.FileWriteStream;

extern class FileSystem {
	// sys.FileSystem-like functions

	/**
		Tests specific user permissions for the file specified by `path`. If the
		check fails, throws an exception. `mode` is one or more `FileAccessMode`
		values:

		- `FileAccessMode.Ok` - file is visible to the calling process (it exists)
		- `FileAccessMode.Execute` - file can be executed by the calling proces
		- `FileAccessMode.Write` - file can be written to by the calling proces
		- `FileAccessMode.Read` - file can be read from by the calling proces

		Mode values can be combined with the `|` operator, e.g. calling `access`
		with `mode` `FileAccessMode.Execute | FileAccessMode.Read` will check that
		the file is both readable and executable.

		The result of this call should not be used in a condition before a call to
		e.g. `open`, because this would introduce a race condition (the file could
		be deleted after the `access` call, but before the `open` call). Instead,
		the latter function should be called immediately and errors should be
		handled with a `try ... catch` block.
	**/
	static function access(path:FilePath, ?mode:FileAccessMode = FileAccessMode.Ok):Void;

	/**
		Changes the permissions of the file specific by `path` to `mode`.

		If `path` points to a symbolic link, this function will change the
		permissions of the target file, not the symbolic link itself, unless
		`followSymLinks` is set to `false`.

		TODO: `followSymLinks == false` is not implemented and will throw.
	**/
	static function chmod(path:FilePath, mode:FileMode, ?followSymLinks:Bool = true):Void;

	/**
		Changes the owner and group of the file specific by `path` to `uid` and
		`gid`, respectively.

		If `path` points to a symbolic link, this function will change the
		permissions of the target file, not the symbolic link itself, unless
		`followSymLinks` is set to `false`.

		TODO: `followSymLinks == false` is not implemented and will throw.
	**/
	static function chown(path:FilePath, uid:Int, gid:Int, ?followSymLinks:Bool = true):Void;

	static function copyFile(src:FilePath, dest:FilePath, ?flags:FileCopyFlags):Void;
	// static function exists(path:FilePath):Bool; // deprecated in node.js
	// static function createReadStream(path:FilePath, ?options:{?flags:FileOpenFlags, ?mode:FileMode, ?autoClose:Bool, ?start:Int, ?end:Int, ?highWaterMark:Int}):FileReadStream;
	// static function createWriteStream(path:FilePath, ?options:{?flags:FileOpenFlags, ?mode:FileMode, ?autoClose:Bool, ?start:Int}):FileWriteStream;
	static function link(existingPath:FilePath, newPath:FilePath):Void;

	/**
		Creates a directory at the path `path`, with file mode `mode`.

		If `recursive` is `false` (default), this function can only create one
		directory at a time, the last component of `path`. If `recursive` is `true`,
		intermediate directories will be created as needed.
	**/
	static function mkdir(path:FilePath, ?recursive:Bool = false, ?mode:FileMode = 511 /* 0777 */):Void;

	/**
		Creates a unique temporary directory. `prefix` should be a path template
		ending in six `X` characters, which will be replaced with random characters.
		Returns the path to the created directory.

		The generated directory needs to be manually deleted by the process.
	**/
	static function mkdtemp(prefix:FilePath):FilePath;

	/**
		Reads the contents of a directory specified by `path`. Returns an array of
		`FilePath`s relative to the specified directory (i.e. the paths are not
		absolute). The array will not include `.` or `..`.
	**/
	static function readdir(path:FilePath):Array<FilePath>;

	/**
		Same as `readdir`, but returns an array of `DirectoryEntry` values instead.
	**/
	static function readdirTypes(path:FilePath):Array<DirectoryEntry>;

	/**
		Returns the contents (target path) of the symbolic link located at `path`.
	**/
	static function readlink(path:FilePath):FilePath;

	/**
		Returns the canonical path name of `path` (which may be a relative path)
		by resolving `.`, `..`, and symbolic links.
	**/
	static function realpath(path:FilePath):FilePath;

	/**
		Renames the file or directory located at `oldPath` to `newPath`. If a file
		already exists at `newPath`, it is overwritten. If a directory already
		exists at `newPath`, an exception is thrown.
	**/
	static function rename(oldPath:FilePath, newPath:FilePath):Void;

	/**
		Deletes the directory located at `path`. If the directory is not empty or
		cannot be deleted, an error is thrown.
	**/
	static function rmdir(path:FilePath):Void;

	/**
		Returns information about the file located at `path`.

		If `path` points to a symbolic link, this function will return information
		about the target file, not the symbolic link itself, unless `followSymLinks`
		is set to `false`.
	**/
	static function stat(path:FilePath, ?followSymLinks:Bool = true):FileStat;

	/**
		Creates a symbolic link at `path`, pointing to `target`.

		The `type` argument is ignored on all platforms except `Windows`.
	**/
	static function symlink(target:FilePath, path:FilePath, ?type:SymlinkType = SymlinkType.SymlinkDir):Void;

	/**
		Truncates the file located at `path` to exactly `len` bytes. If the file was
		larger than `len` bytes, the extra data is lost. If the file was smaller
		than `len` bytes, the file is extended with null bytes.
	**/
	static function truncate(path:FilePath, ?len:Int = 0):Void;

	/**
		Deletes the file located at `path`.
	**/
	static function unlink(path:FilePath):Void;

	/**
		Modifies the system timestamps of the file located at `path`.
	**/
	static function utimes(path:FilePath, atime:Date, mtime:Date):Void;

	/**
		Creates a file watcher for `path`.

		If `persistent` is `true` (default), the process will not exit until the
		file watcher is closed.

		If `recursive` is `true`, the file watcher will signal for changes in
		sub-directories of `path` as well.
	**/
	static function watch(path:FilePath, ?persistent:Bool = true, ?recursive:Bool = false):FileWatcher;

	// sys.io.File-like functions

	/**
		Appends `data` at the end of the file located at `path`.
	**/
	static function appendFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags = FileOpenFlags.Append, ?mode:FileMode = 438 /* 0666 */):Void;

	/**
		Opens the file located at `path`.
	**/
	static function open(path:FilePath, ?flags:FileOpenFlags = FileOpenFlags.Read, ?mode:FileMode = 438 /* 0666 */, ?binary:Bool = true):sys.io.File;

	/**
		Reads all the bytes of the file located at `path`.
	**/
	static function readFile(path:FilePath, ?flags:FileOpenFlags = FileOpenFlags.Read):Bytes;

	/**
		Writes `data` to the file located at `path`.
	**/
	static function writeFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags = FileOpenFlags.WriteTruncate, ?mode:FileMode = 438 /* 0666 */):Void;

	// compatibility sys.FileSystem functions
	static function absolutePath(path:String):String; // should be implemented in haxe.io.Path
	static inline function createDirectory(path:String):Void return mkdir(path, true);
	static inline function deleteDirectory(path:String):Void return rmdir(path);
	static inline function deleteFile(path:String):Void return unlink(path);
	static inline function exists(path:String):Bool
		return try {
			access(path);
			true;
		} catch (e:Dynamic) false;
	static inline function fullPath(path:String):FilePath return realpath(path);
	static inline function isDirectory(path:String):Bool return stat(path).isDirectory();
	static inline function readDirectory(path:String):Array<FilePath> return readdir(path);
	// static function rename(path:String, newPath:String) return rename(path, newPath); // matching interface
	// static function stat(path:String) return stat(path); // matching interface (more or less)
}
