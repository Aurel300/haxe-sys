package asys;

import haxe.Error;
import haxe.io.Bytes;
import haxe.io.FilePath;
import asys.io.*;
import hl.Uv;
import hl.uv.Loop;

@:access(haxe.io.FilePath)
@:access(asys.FileAccessMode)
@:access(asys.FileOpenFlags)
@:access(asys.FilePermissions)
@:access(asys.SymlinkType)
@:access(asys.io.File)
class FileSystem {
	@:hlNative("uv", "w_fs_open_sync") static function w_fs_open_sync(loop:Loop, _:hl.Bytes, _:Int, _:Int):File return null;
	@:hlNative("uv", "w_fs_unlink_sync") static function w_fs_unlink_sync(loop:Loop, _:hl.Bytes):Void {}
	@:hlNative("uv", "w_fs_mkdir_sync") static function w_fs_mkdir_sync(loop:Loop, _:hl.Bytes, _:Int):Void {}
	@:hlNative("uv", "w_fs_mkdtemp_sync") static function w_fs_mkdtemp_sync(loop:Loop, _:hl.Bytes):hl.Bytes return null;
	@:hlNative("uv", "w_fs_rmdir_sync") static function w_fs_rmdir_sync(loop:Loop, _:hl.Bytes):Void {}
	@:hlNative("uv", "w_fs_scandir_sync") static function w_fs_scandir_sync(loop:Loop, _:hl.Bytes, _:Int):hl.NativeArray<hl.uv.DirectoryEntry> return null;
	@:hlNative("uv", "w_fs_stat_sync") static function w_fs_stat_sync(loop:Loop, _:hl.Bytes):asys.uv.UVStat return null;
	@:hlNative("uv", "w_fs_lstat_sync") static function w_fs_lstat_sync(loop:Loop, _:hl.Bytes):asys.uv.UVStat return null;
	@:hlNative("uv", "w_fs_rename_sync") static function w_fs_rename_sync(loop:Loop, _:hl.Bytes, _:hl.Bytes):Void {}
	@:hlNative("uv", "w_fs_access_sync") static function w_fs_access_sync(loop:Loop, _:hl.Bytes, _:Int):Void {}
	@:hlNative("uv", "w_fs_chmod_sync") static function w_fs_chmod_sync(loop:Loop, _:hl.Bytes, _:Int):Void {}
	@:hlNative("uv", "w_fs_utime_sync") static function w_fs_utime_sync(loop:Loop, _:hl.Bytes, _:Float, _:Float):Void {}
	@:hlNative("uv", "w_fs_link_sync") static function w_fs_link_sync(loop:Loop, _:hl.Bytes, _:hl.Bytes):Void {}
	@:hlNative("uv", "w_fs_symlink_sync") static function w_fs_symlink_sync(loop:Loop, _:hl.Bytes, _:hl.Bytes, _:Int):Void {}
	@:hlNative("uv", "w_fs_readlink_sync") static function w_fs_readlink_sync(loop:Loop, _:hl.Bytes):hl.Bytes return null;
	@:hlNative("uv", "w_fs_realpath_sync") static function w_fs_realpath_sync(loop:Loop, _:hl.Bytes):hl.Bytes return null;
	@:hlNative("uv", "w_fs_chown_sync") static function w_fs_chown_sync(loop:Loop, _:hl.Bytes, _:Int, _:Int):Void {}

	public static inline final async = asys.AsyncFileSystem;

	public static function access(path:FilePath, ?mode:FileAccessMode = FileAccessMode.Ok):Void {
		w_fs_access_sync(Uv.loop, path.decodeHl(), mode.get_raw());
	}

	public static function chmod(path:FilePath, mode:FilePermissions, ?followSymLinks:Bool = true):Void {
		if (followSymLinks)
			w_fs_chmod_sync(Uv.loop, path.decodeHl(), mode.get_raw());
		else
			throw "not implemented";
		// w_fs_lchmod_sync(Uv.loop, path.decodeHl(), mode.get_raw());
	}

	public static function chown(path:FilePath, uid:Int, gid:Int, ?followSymLinks:Bool = true):Void {
		if (followSymLinks)
			w_fs_chown_sync(Uv.loop, path.decodeHl(), uid, gid);
		else
			throw "not implemented";
		// w_fs_lchown_sync(Uv.loop, path.decodeHl(), uid, gid);
	}

	public static function copyFile(src:FilePath, dest:FilePath /* , ?flags:FileCopyFlags */):Void {
		throw "not implemented";
	}

	// static function createReadStream(path:FilePath, ?options:{?flags:FileOpenFlags, ?mode:FilePermissions, ?autoClose:Bool, ?start:Int, ?end:Int, ?highWaterMark:Int}):FileReadStream;
	// static function createWriteStream(path:FilePath, ?options:{?flags:FileOpenFlags, ?mode:FilePermissions, ?autoClose:Bool, ?start:Int}):FileWriteStream;

	public static function exists(path:FilePath):Bool {
		return (try {
			w_fs_access_sync(Uv.loop, path.decodeHl(), 0);
			true;
		} catch (_:Dynamic) false);
	}

	public static function link(existingPath:FilePath, newPath:FilePath):Void {
		w_fs_link_sync(Uv.loop, existingPath.decodeHl(), newPath.decodeHl());
	}

	public static function mkdir(path:FilePath, ?recursive:Bool = false, ?mode:FilePermissions):Void {
		if (mode == null)
			mode = @:privateAccess new FilePermissions(511); // 0777
		if (!recursive)
			return w_fs_mkdir_sync(Uv.loop, path.decodeHl(), mode.get_raw());
		var pathBuffer:FilePath = null;
		for (component in path.components) {
			if (pathBuffer == null)
				pathBuffer = component;
			else
				pathBuffer = pathBuffer / component;
			try {
				w_fs_mkdir_sync(Uv.loop, pathBuffer.decodeHl(), mode.get_raw());
			} catch (e:Error) {
				if (e.type.match(haxe.ErrorType.UVError(asys.uv.UVErrorType.EEXIST)))
					continue;
				hl.Api.rethrow(e);
			}
		}
	}

	public static function mkdtemp(prefix:FilePath):FilePath {
		return FilePath.encodeHl(w_fs_mkdtemp_sync(Uv.loop, prefix.decodeHl()));
	}

	public static function readdir(path:FilePath):Array<FilePath> {
		return readdirTypes(path).map(entry -> entry.name);
	}

	public static function readdirTypes(path:FilePath):Array<asys.DirectoryEntry> {
		var native = w_fs_scandir_sync(Uv.loop, path.decodeHl(), 0);
		return [for (i in 0...native.length) native[i]];
	}

	public static function readlink(path:FilePath):FilePath {
		return FilePath.encodeHl(w_fs_readlink_sync(Uv.loop, path.decodeHl()));
	}

	public static function realpath(path:FilePath):FilePath {
		return FilePath.encodeHl(w_fs_realpath_sync(Uv.loop, path.decodeHl()));
	}

	public static function rename(oldPath:FilePath, newPath:FilePath):Void {
		w_fs_rename_sync(Uv.loop, oldPath.decodeHl(), newPath.decodeHl());
	}

	public static function rmdir(path:FilePath):Void {
		w_fs_rmdir_sync(Uv.loop, path.decodeHl());
	}

	public static function stat(path:FilePath, ?followSymLinks:Bool = true):asys.uv.UVStat {
		if (followSymLinks)
			return w_fs_stat_sync(Uv.loop, path.decodeHl());
		return w_fs_lstat_sync(Uv.loop, path.decodeHl());
	}

	public static function symlink(target:FilePath, path:FilePath, ?type:SymlinkType = SymlinkType.SymlinkDir):Void {
		w_fs_symlink_sync(Uv.loop, target.decodeHl(), path.decodeHl(), type.get_raw());
	}

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

	public static function unlink(path:FilePath):Void {
		w_fs_unlink_sync(Uv.loop, path.decodeHl());
	}

	public static function utimes(path:FilePath, atime:Date, mtime:Date):Void {
		w_fs_utime_sync(Uv.loop, path.decodeHl(), atime.getTime() / 1000, mtime.getTime() / 1000);
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
		return w_fs_open_sync(Uv.loop, path.decodeHl(), flags.get_raw(), mode.get_raw());
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
