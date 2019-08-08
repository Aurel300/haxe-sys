package nusys;

import haxe.Error;
import haxe.io.Bytes;
import haxe.io.FilePath;
import sys.*;
import nusys.io.FileReadStream;

typedef FileReadStreamCreationOptions = {
	?flags:FileOpenFlags,
	?mode:FilePermissions
} &
	nusys.io.FileReadStream.FileReadStreamOptions;

class FileSystem {
	public static final async = nusys.async.FileSystem;

	extern public static function access(path:FilePath, ?mode:FileAccessMode = FileAccessMode.Ok):Void;

	extern public static function chmod(path:FilePath, mode:FilePermissions, ?followSymLinks:Bool = true):Void;

	extern public static function chown(path:FilePath, uid:Int, gid:Int, ?followSymLinks:Bool = true):Void;

	extern public static function exists(path:FilePath):Bool;

	public static function createReadStream(path:FilePath, ?options:FileReadStreamCreationOptions):FileReadStream {
		if (options == null)
			options = {};
		return new FileReadStream(open(path, options.flags, options.mode), options);
	}

	// static function createWriteStream(path:FilePath, ?options:{?flags:FileOpenFlags, ?mode:FilePermissions, ?autoClose:Bool, ?start:Int}):FileWriteStream;

	extern public static function link(existingPath:FilePath, newPath:FilePath):Void;

	extern static function mkdir_native(path:FilePath, mode:FilePermissions):Void;

	public static function mkdir(path:FilePath, ?recursive:Bool = false, ?mode:FilePermissions):Void {
		if (mode == null)
			mode = FilePermissions.fromOctal("777");
		if (!recursive)
			return mkdir_native(path, mode);
		var pathBuffer:FilePath = null;
		for (component in path.components) {
			if (pathBuffer == null)
				pathBuffer = component;
			else
				pathBuffer = pathBuffer / component;
			try {
				mkdir_native(pathBuffer, mode);
			} catch (e:Error) {
				if (e.type.match(UVError(sys.uv.UVErrorType.EEXIST)))
					continue;
				throw e;
			}
		}
	}

	extern public static function mkdtemp(prefix:FilePath):FilePath;

	public static function readdir(path:FilePath):Array<FilePath> {
		return readdirTypes(path).map(entry -> entry.name);
	}

	extern public static function readdirTypes(path:FilePath):Array<eval.uv.DirectoryEntry>;

	extern public static function readlink(path:FilePath):FilePath;

	extern public static function realpath(path:FilePath):FilePath;

	extern public static function rename(oldPath:FilePath, newPath:FilePath):Void;

	extern public static function rmdir(path:FilePath):Void;

	extern public static function stat(path:FilePath, ?followSymLinks:Bool = true):eval.uv.Stat;

	extern public static function symlink(target:FilePath, path:FilePath, ?type:SymlinkType = SymlinkType.SymlinkDir):Void;

	public static function truncate(path:FilePath, len:Int):Void {
		var f = open(path, FileOpenFlags.ReadWrite);
		try {
			f.truncate(len);
		} catch (e:Dynamic) {
			f.close();
			throw e;
		}
		f.close();
	}

	extern public static function unlink(path:FilePath):Void;

	extern static function utimes_native(path:FilePath, atime:Float, mtime:Float):Void;

	public static function utimes(path:FilePath, atime:Date, mtime:Date):Void {
		utimes_native(path, atime.getTime(), mtime.getTime());
	}

	extern static function watch_native(filename:FilePath, ?persistent:Bool = true, ?recursive:Bool = false,
		cb:(error:Error, path:FilePath, event:sys.uv.UVFsEventType) -> Void):eval.uv.FileWatcher;

	public static function watch(filename:FilePath, ?persistent:Bool = true, ?recursive:Bool = false):sys.FileWatcher {
		var watcher:sys.FileWatcher = null;
		var handle = watch_native(filename, persistent, recursive, (error, path, event) -> {
			if (error != null)
				watcher.errorSignal.emit(error);
			else
				watcher.changeSignal.emit(switch (event) {
					case sys.uv.UVFsEventType.Rename:
						sys.FileWatcherEvent.Rename(path);
					case sys.uv.UVFsEventType.Change:
						sys.FileWatcherEvent.Change(path);
					case _:
						sys.FileWatcherEvent.RenameChange(path);
				});
		});
		watcher = @:privateAccess new sys.FileWatcher(handle);
		return watcher;
	}

	extern static function open_native(path:FilePath, flags:FileOpenFlags, mode:FilePermissions, binary:Bool):nusys.io.File;

	public static function open(path:FilePath, ?flags:FileOpenFlags = FileOpenFlags.ReadOnly, ?mode:FilePermissions, ?binary:Bool = true):nusys.io.File {
		if (mode == null)
			mode = @:privateAccess new FilePermissions(438) /* 0666 */;
		return open_native(path, flags, mode, binary);
	}

	public static function readFile(path:FilePath, ?flags:FileOpenFlags = FileOpenFlags.ReadOnly):Bytes {
		var file = open(path, flags);
		var buffer:haxe.io.Bytes;
		try {
			var size = file.stat().size;
			buffer = Bytes.alloc(size);
			file.read(buffer, 0, size, 0);
		} catch (e:Dynamic) {
			file.close();
			throw e;
		}
		file.close();
		return buffer;
	}

	// compatibility sys.FileSystem functions
	////static inline function absolutePath(path:String):String; // should be implemented in haxe.io.Path?
	public static inline function createDirectory(path:String):Void return mkdir(path, true);

	public static inline function deleteDirectory(path:String):Void
		rmdir(path);

	public static inline function deleteFile(path:String):Void
		unlink(path);

	public static inline function fullPath(path:String):FilePath return realpath(path);

	public static inline function isDirectory(path:String):Bool return stat(path).isDirectory();

	public static inline function readDirectory(path:String):Array<FilePath> return readdir(path);

	// static function rename(path:String, newPath:String) return rename(path, newPath); // matching interface
	// static function stat(path:String) return stat(path); // matching interface (more or less)
}
