package asys;

import haxe.Error;
import haxe.io.Bytes;
import haxe.io.FilePath;
import asys.io.*;
import neko.Uv;
import neko.uv.Loop;

@:access(haxe.io.FilePath)
@:access(asys.FileAccessMode)
@:access(asys.FileOpenFlags)
@:access(asys.FilePermissions)
@:access(asys.SymlinkType)
@:access(asys.io.File)
class FileSystem {
	static var w_fs_open_sync:(Loop, neko.NativeString, Int, Int)->File = neko.Lib.load("uv", "w_fs_open_sync", 4);
	static var w_fs_unlink_sync:(Loop, neko.NativeString)->Void = neko.Lib.load("uv", "w_fs_unlink_sync", 2);
	static var w_fs_mkdir_sync:(Loop, neko.NativeString, Int)->Void = neko.Lib.load("uv", "w_fs_mkdir_sync", 3);
	static var w_fs_mkdtemp_sync:(Loop, neko.NativeString)->neko.NativeString = neko.Lib.load("uv", "w_fs_mkdtemp_sync", 2);
	static var w_fs_rmdir_sync:(Loop, neko.NativeString)->Void = neko.Lib.load("uv", "w_fs_rmdir_sync", 2);
	static var w_fs_scandir_sync:(Loop, neko.NativeString, Int)->neko.NativeArray<neko.uv.DirectoryEntry> = neko.Lib.load("uv", "w_fs_scandir_sync", 3);
	static var w_fs_stat_sync:(Loop, neko.NativeString)->asys.uv.UVStat = neko.Lib.load("uv", "w_fs_stat_sync", 2);
	static var w_fs_lstat_sync:(Loop, neko.NativeString)->asys.uv.UVStat = neko.Lib.load("uv", "w_fs_lstat_sync", 2);
	static var w_fs_rename_sync:(Loop, neko.NativeString, neko.NativeString)->Void = neko.Lib.load("uv", "w_fs_rename_sync", 3);
	static var w_fs_access_sync:(Loop, neko.NativeString, Int)->Void = neko.Lib.load("uv", "w_fs_access_sync", 3);
	static var w_fs_chmod_sync:(Loop, neko.NativeString, Int)->Void = neko.Lib.load("uv", "w_fs_chmod_sync", 3);
	static var w_fs_utime_sync:(Loop, neko.NativeString, Float, Float)->Void = neko.Lib.load("uv", "w_fs_utime_sync", 4);
	static var w_fs_link_sync:(Loop, neko.NativeString, neko.NativeString)->Void = neko.Lib.load("uv", "w_fs_link_sync", 3);
	static var w_fs_symlink_sync:(Loop, neko.NativeString, neko.NativeString, Int)->Void = neko.Lib.load("uv", "w_fs_symlink_sync", 4);
	static var w_fs_readlink_sync:(Loop, neko.NativeString)->neko.NativeString = neko.Lib.load("uv", "w_fs_readlink_sync", 2);
	static var w_fs_realpath_sync:(Loop, neko.NativeString)->neko.NativeString = neko.Lib.load("uv", "w_fs_realpath_sync", 2);
	static var w_fs_chown_sync:(Loop, neko.NativeString, Int, Int)->Void = neko.Lib.load("uv", "w_fs_chown_sync", 4);

	public static inline final async = asys.AsyncFileSystem;

	public static function access(path:FilePath, ?mode:FileAccessMode = FileAccessMode.Ok):Void {
		w_fs_access_sync(Uv.loop, path.decodeNative(), mode.get_raw());
	}

	public static function chmod(path:FilePath, mode:FilePermissions, ?followSymLinks:Bool = true):Void {
		if (followSymLinks)
			w_fs_chmod_sync(Uv.loop, path.decodeNative(), mode.get_raw());
		else
			throw "not implemented";
		// w_fs_lchmod_sync(Uv.loop, path.decodeNative(), mode.get_raw());
	}

	public static function chown(path:FilePath, uid:Int, gid:Int, ?followSymLinks:Bool = true):Void {
		if (followSymLinks)
			w_fs_chown_sync(Uv.loop, path.decodeNative(), uid, gid);
		else
			throw "not implemented";
		// w_fs_lchown_sync(Uv.loop, path.decodeNative(), uid, gid);
	}

	public static function copyFile(src:FilePath, dest:FilePath /* , ?flags:FileCopyFlags */):Void {
		throw "not implemented";
	}

	// static function createReadStream(path:FilePath, ?options:{?flags:FileOpenFlags, ?mode:FilePermissions, ?autoClose:Bool, ?start:Int, ?end:Int, ?highWaterMark:Int}):FileReadStream;
	// static function createWriteStream(path:FilePath, ?options:{?flags:FileOpenFlags, ?mode:FilePermissions, ?autoClose:Bool, ?start:Int}):FileWriteStream;

	public static function exists(path:FilePath):Bool {
		return (try {
			w_fs_access_sync(Uv.loop, path.decodeNative(), 0);
			true;
		} catch (_:Dynamic) false);
	}

	public static function link(existingPath:FilePath, newPath:FilePath):Void {
		w_fs_link_sync(Uv.loop, existingPath.decodeNative(), newPath.decodeNative());
	}

	public static function mkdir(path:FilePath, ?recursive:Bool = false, ?mode:FilePermissions):Void {
		if (mode == null)
			mode = @:privateAccess new FilePermissions(511); // 0777
		if (!recursive)
			return w_fs_mkdir_sync(Uv.loop, path.decodeNative(), mode.get_raw());
		var pathBuffer:FilePath = null;
		for (component in path.components) {
			if (pathBuffer == null)
				pathBuffer = component;
			else
				pathBuffer = pathBuffer / component;
			try {
				w_fs_mkdir_sync(Uv.loop, pathBuffer.decodeNative(), mode.get_raw());
			} catch (e:Error) {
				if (e.type.match(haxe.ErrorType.UVError(asys.uv.UVErrorType.EEXIST)))
					continue;
				throw e;
			}
		}
	}

	public static function mkdtemp(prefix:FilePath):FilePath {
		return FilePath.encodeNative(w_fs_mkdtemp_sync(Uv.loop, prefix.decodeNative()));
	}

	public static function readdir(path:FilePath):Array<FilePath> {
		return readdirTypes(path).map(entry -> entry.name);
	}

	public static function readdirTypes(path:FilePath):Array<neko.uv.DirectoryEntry> {
		return neko.NativeArray.toArray(w_fs_scandir_sync(Uv.loop, path.decodeNative(), 0));
	}

	public static function readlink(path:FilePath):FilePath {
		return FilePath.encodeNative(w_fs_readlink_sync(Uv.loop, path.decodeNative()));
	}

	public static function realpath(path:FilePath):FilePath {
		return FilePath.encodeNative(w_fs_realpath_sync(Uv.loop, path.decodeNative()));
	}

	public static function rename(oldPath:FilePath, newPath:FilePath):Void {
		w_fs_rename_sync(Uv.loop, oldPath.decodeNative(), newPath.decodeNative());
	}

	public static function rmdir(path:FilePath):Void {
		w_fs_rmdir_sync(Uv.loop, path.decodeNative());
	}

	public static function stat(path:FilePath, ?followSymLinks:Bool = true):asys.uv.UVStat {
		if (followSymLinks)
			return w_fs_stat_sync(Uv.loop, path.decodeNative());
		return w_fs_lstat_sync(Uv.loop, path.decodeNative());
	}

	public static function symlink(target:FilePath, path:FilePath, ?type:SymlinkType = SymlinkType.SymlinkDir):Void {
		w_fs_symlink_sync(Uv.loop, target.decodeNative(), path.decodeNative(), type.get_raw());
	}

	public static function truncate(path:FilePath, ?len:Int = 0):Void {
		var f = open(path, FileOpenFlags.ReadWrite);
		try {
			f.truncate(len);
		} catch (e:Dynamic) {
			f.close();
			throw e;
		}
		f.close();
	}

	public static function unlink(path:FilePath):Void {
		w_fs_unlink_sync(Uv.loop, path.decodeNative());
	}

	public static function utimes(path:FilePath, atime:Date, mtime:Date):Void {
		w_fs_utime_sync(Uv.loop, path.decodeNative(), atime.getTime() / 1000, mtime.getTime() / 1000);
	}

	public static function watch(path:FilePath, ?recursive:Bool = false):FileWatcher {
		return @:privateAccess new FileWatcher(path, recursive);
	}

	/*
	public static function appendFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags = FileOpenFlags.Append, ?mode:FilePermissions = 438 /* 0666 * /):Void
		writeFile(path, data, flags, mode);
	*/

	public static function open(path:FilePath, ?flags:FileOpenFlags = FileOpenFlags.ReadOnly, ?mode:FilePermissions, ?binary:Bool = true):asys.io.File {
		if (mode == null)
			mode = @:privateAccess new FilePermissions(438); // 0666
		return w_fs_open_sync(Uv.loop, path.decodeNative(), flags.get_raw(), mode.get_raw());
	}

	public static function readFile(path:FilePath, ?flags:FileOpenFlags = FileOpenFlags.ReadOnly):Bytes {
		var file = open(path, flags);
		var buffer:haxe.io.Bytes;
		try {
			var size = file.stat().size;
			buffer = haxe.io.Bytes.alloc(size);
			file.readBuffer(buffer, 0, size, 0);
		} catch (e:Dynamic) {
			file.close();
			throw e;
		}
		file.close();
		return buffer;
	}

	@:access(asys.FileOpenFlags)
	public static function writeFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags, ?mode:FilePermissions):Void {
		if (flags == null)
			flags = "w";
		if (mode == null)
			mode = @:privateAccess new FilePermissions(438) /* 0666 */;
		var file = open(path, flags, mode);
		var offset = 0;
		var length = data.length;
		var position:Null<Int> = null;
		if (flags.get_raw() & FileOpenFlags.Append.get_raw() == 0)
			position = 0;
		try {
			while (length > 0) {
				var written = file.writeBuffer(data, offset, length, position).bytesWritten;
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
}
