package nusys;

import haxe.Error;
import haxe.io.Bytes;
import haxe.io.FilePath;
import sys.FileAccessMode;
import sys.FileOpenFlags;
import sys.FilePermissions;
import sys.SymlinkType;

// import sys.io.FileReadStream;
// import sys.io.FileWriteStream;
@:access(haxe.io.FilePath)
@:access(sys.FileAccessMode)
@:access(sys.FileOpenFlags)
@:access(sys.FilePermissions)
@:access(sys.SymlinkType)
@:access(nusys.io.File)
class FileSystem {
	// sys.FileSystem-like functions
	public static function access(path:FilePath, ?mode:FileAccessMode = FileAccessMode.Ok):Void
		UV.fs_access_sync(UV.loop, path.decodeHl(), mode.get_raw());

	public static function chmod(path:FilePath, mode:FilePermissions, ?followSymLinks:Bool = true):Void {
		if (followSymLinks)
			UV.fs_chmod_sync(UV.loop, path.decodeHl(), mode.get_raw());
		else
			throw "not implemented";
		// UV.fs_lchmod_sync(UV.loop, path.decodeHl(), mode.get_raw());
	}

	public static function chown(path:FilePath, uid:Int, gid:Int, ?followSymLinks:Bool = true):Void {
		if (followSymLinks)
			UV.fs_chown_sync(UV.loop, path.decodeHl(), uid, gid);
		else
			throw "not implemented";
		// UV.fs_lchown_sync(UV.loop, path.decodeHl(), uid, gid);
	}

	// static function copyFile(src:FilePath, dest:FilePath, ?flags:FileCopyFlags):Void;
	// static function createReadStream(path:FilePath, ?options:{?flags:FileOpenFlags, ?mode:FilePermissions, ?autoClose:Bool, ?start:Int, ?end:Int, ?highWaterMark:Int}):FileReadStream;
	// static function createWriteStream(path:FilePath, ?options:{?flags:FileOpenFlags, ?mode:FilePermissions, ?autoClose:Bool, ?start:Int}):FileWriteStream;
	public static function link(existingPath:FilePath, newPath:FilePath):Void
		UV.fs_link_sync(UV.loop, existingPath.decodeHl(), newPath.decodeHl());

	public static function mkdir(path:FilePath, ?recursive:Bool = false, ?mode:FilePermissions = 511 /* 0777 */):Void {
		if (!recursive)
			return UV.fs_mkdir_sync(UV.loop, path.decodeHl(), mode.get_raw());
		var pathBuffer:FilePath = null;
		for (component in path.components) {
			if (pathBuffer == null)
				pathBuffer = component;
			else
				pathBuffer = pathBuffer / component;
			try {
				UV.fs_mkdir_sync(UV.loop, pathBuffer.decodeHl(), mode.get_raw());
			} catch (e:Error) {
				if (e.type.match(haxe.ErrorType.UVError(sys.uv.UVErrorType.EEXIST)))
					continue;
				hl.Api.rethrow(e);
			}
		}
	}

	public static function mkdtemp(prefix:FilePath):FilePath return FilePath.encodeHl(UV.fs_mkdtemp_sync(UV.loop, prefix.decodeHl()));

	public static function readdir(path:FilePath):Array<FilePath> return readdirTypes(path).map(entry -> entry.name);

	public static function readdirTypes(path:FilePath):Array<sys.DirectoryEntry> {
		var native = UV.fs_scandir_sync(UV.loop, path.decodeHl(), 0);
		return [for (i in 0...native.length) native[i]];
	}

	public static function readlink(path:FilePath):FilePath return FilePath.encodeHl(UV.fs_readlink_sync(UV.loop, path.decodeHl()));

	public static function realpath(path:FilePath):FilePath return FilePath.encodeHl(UV.fs_realpath_sync(UV.loop, path.decodeHl()));

	public static function rename(oldPath:FilePath, newPath:FilePath):Void
		UV.fs_rename_sync(UV.loop, oldPath.decodeHl(), newPath.decodeHl());

	public static function rmdir(path:FilePath):Void
		UV.fs_rmdir_sync(UV.loop, path.decodeHl());

	public static function stat(path:FilePath, ?followSymLinks:Bool = true):sys.uv.UVStat {
		if (followSymLinks)
			return UV.fs_stat_sync(UV.loop, path.decodeHl());
		return UV.fs_lstat_sync(UV.loop, path.decodeHl());
	}

	public static function symlink(target:FilePath, path:FilePath, ?type:SymlinkType = SymlinkType.SymlinkDir):Void
		UV.fs_symlink_sync(UV.loop, target.decodeHl(), path.decodeHl(), type.get_raw());

	public static function truncate(path:FilePath, ?len:Int = 0):Void {
		var f = open(path, FileOpenFlags.ReadWrite);
		try {
			f.truncate(len);
		} catch (e:Dynamic) {
			f.close();
			hl.Api.rethrow(e);
		}
		f.close();
	}

	public static function unlink(path:FilePath):Void
		UV.fs_unlink_sync(UV.loop, path.decodeHl());

	public static function utimes(path:FilePath, atime:Date, mtime:Date):Void
		UV.fs_utime_sync(UV.loop, path.decodeHl(), atime.getTime() / 1000, mtime.getTime() / 1000);

	public static function watch(filename:FilePath, ?persistent:Bool = true, ?recursive:Bool = false):sys.FileWatcher {
		var handle = UV.fs_event_init(UV.loop);
		var watcher = @:privateAccess new sys.FileWatcher(handle);
		UV.fs_event_start(handle, filename.decodeHl(), recursive ? UV.FS_EVENT_RECURSIVE : 0, (error, path, event) -> {
			if (error != null)
				watcher.errorSignal.emit(error);
			else
				watcher.changeSignal.emit(switch (event) {
					case sys.uv.UVFsEventType.Rename:
						sys.FileWatcherEvent.Rename(FilePath.encodeHl(path));
					case _ /* Change */:
						sys.FileWatcherEvent.Change(FilePath.encodeHl(path));
				});
		});
		return watcher;
	}

	// sys.io.File-like functions
	public static function appendFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags = FileOpenFlags.Append, ?mode:FilePermissions = 438 /* 0666 */):Void
		writeFile(path, data, flags, mode);

	public static function open(path:FilePath, ?flags:FileOpenFlags = FileOpenFlags.ReadOnly, ?mode:FilePermissions = 438 /* 0666 */,
			?binary:Bool = true):nusys.io.File {
		var handle = UV.fs_open_sync(UV.loop, path.decodeHl(), flags.get_raw(), mode.get_raw());
		return new nusys.io.File(handle);
	}

	public static function readFile(path:FilePath, ?flags:FileOpenFlags = FileOpenFlags.ReadOnly):Bytes {
		var file = open(path, flags);
		var buffer:haxe.io.Bytes;
		try {
			var size = file.stat().size;
			buffer = haxe.io.Bytes.alloc(size);
			file.read(buffer, 0, size, 0);
		} catch (e:Dynamic) {
			file.close();
			throw e;
		}
		file.close();
		return buffer;
	}

	public static function writeFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags, ?mode:FilePermissions = 438 /* 0666 */):Void {
		if (flags == null)
			flags = "w";
		var file = open(path, flags, mode);
		var offset = 0;
		var length = data.length;
		var position:Null<Int> = null;
		if (flags.get_raw() & FileOpenFlags.Append.get_raw() == 0)
			position = 0;
		try {
			while (length > 0) {
				var written = file.write(data, offset, length, position).bytesWritten;
				offset += written;
				length -= written;
				if (position != null) {
					position += written;
				}
			}
		} catch (e:Dynamic) {
			file.close();
			throw e;
		}
	}

	// compatibility sys.FileSystem functions
	////static inline function absolutePath(path:String):String; // should be implemented in haxe.io.Path?
	public static inline function createDirectory(path:String):Void return mkdir(path, true);

	public static inline function deleteDirectory(path:String):Void
		rmdir(path);

	public static inline function deleteFile(path:String):Void
		unlink(path);

	public static inline function exists(path:String):Bool
		return try {
			access(path);
			true;
		} catch (e:Dynamic) false;

	public static inline function fullPath(path:String):FilePath return realpath(path);

	public static inline function isDirectory(path:String):Bool return stat(path).isDirectory();

	public static inline function readDirectory(path:String):Array<FilePath> return readdir(path);

	// static function rename(path:String, newPath:String) return rename(path, newPath); // matching interface
	// static function stat(path:String) return stat(path); // matching interface (more or less)
}
