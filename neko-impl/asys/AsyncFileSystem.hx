package asys;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;
import haxe.io.FilePath;
import asys.io.*;
import neko.Uv;
import neko.uv.Loop;

@:access(haxe.async.Callback)
@:access(haxe.io.FilePath)
@:access(asys.FileAccessMode)
@:access(asys.FileOpenFlags)
@:access(asys.FilePermissions)
@:access(asys.SymlinkType)
@:access(asys.io.File)
class AsyncFileSystem {
	static var w_fs_open:(Loop, neko.NativeString, Int, Int, (Dynamic, File)->Void)->Void = neko.Lib.load("uv", "w_fs_open", 5);
	static var w_fs_unlink:(Loop, neko.NativeString, (Dynamic, Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_unlink", 3);
	static var w_fs_mkdir:(Loop, neko.NativeString, Int, (Dynamic, Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_mkdir", 4);
	static var w_fs_mkdtemp:(Loop, neko.NativeString, (Dynamic, neko.NativeString)->Void)->Void = neko.Lib.load("uv", "w_fs_mkdtemp", 3);
	static var w_fs_rmdir:(Loop, neko.NativeString, (Dynamic, Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_rmdir", 3);
	static var w_fs_scandir:(Loop, neko.NativeString, Int, (Dynamic, neko.NativeArray<neko.uv.DirectoryEntry>)->Void)->Void = neko.Lib.load("uv", "w_fs_scandir", 4);
	static var w_fs_stat:(Loop, neko.NativeString, (Dynamic, asys.uv.UVStat)->Void)->Void = neko.Lib.load("uv", "w_fs_stat", 3);
	static var w_fs_lstat:(Loop, neko.NativeString, (Dynamic, asys.uv.UVStat)->Void)->Void = neko.Lib.load("uv", "w_fs_lstat", 3);
	static var w_fs_rename:(Loop, neko.NativeString, neko.NativeString, (Dynamic, Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_rename", 4);
	static var w_fs_access:(Loop, neko.NativeString, Int, (Dynamic, Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_access", 4);
	static var w_fs_chmod:(Loop, neko.NativeString, Int, (Dynamic, Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_chmod", 4);
	static var w_fs_utime:(Loop, neko.NativeString, Float, Float, (Dynamic, Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_utime", 5);
	static var w_fs_link:(Loop, neko.NativeString, neko.NativeString, (Dynamic, Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_link", 4);
	static var w_fs_symlink:(Loop, neko.NativeString, neko.NativeString, Int, (Dynamic, Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_symlink", 5);
	static var w_fs_readlink:(Loop, neko.NativeString, (Dynamic, neko.NativeString)->Void)->Void = neko.Lib.load("uv", "w_fs_readlink", 3);
	static var w_fs_realpath:(Loop, neko.NativeString, (Dynamic, neko.NativeString)->Void)->Void = neko.Lib.load("uv", "w_fs_realpath", 3);
	static var w_fs_chown:(Loop, neko.NativeString, Int, Int, (Dynamic, Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_chown", 5);

	// sys.FileSystem-like functions
	public static function access(path:FilePath, ?mode:FileAccessMode = FileAccessMode.Ok, callback:Callback<NoData>):Void {
		w_fs_access(Uv.loop, path.decodeNative(), mode.get_raw(), cast callback);
	}

	public static function chmod(path:FilePath, mode:FilePermissions, ?followSymLinks:Bool = true, callback:Callback<NoData>):Void {
		if (followSymLinks)
			w_fs_chmod(Uv.loop, path.decodeNative(), mode.get_raw(), cast callback);
		else
			throw "not implemented";
		// w_fs_lchmod(Uv.loop, path.decodeNative(), mode.get_raw(), cast callback);
	}

	public static function chown(path:FilePath, uid:Int, gid:Int, ?followSymLinks:Bool = true, callback:Callback<NoData>):Void {
		if (followSymLinks)
			w_fs_chown(Uv.loop, path.decodeNative(), uid, gid, cast callback);
		else
			throw "not implemented";
		// w_fs_lchown(Uv.loop, path.decodeNative(), uid, gid, cast callback);
	}

	// static function copyFile(src:FilePath, dest:FilePath, ?flags:FileCopyFlags, callback:Callback<NoData>):Void;
	public static function exists(path:FilePath, callback:Callback<Bool>):Void {
		access(path, (error, _) -> callback(error == null));
	}

	public static function link(existingPath:FilePath, newPath:FilePath, callback:Callback<NoData>):Void {
		w_fs_link(Uv.loop, existingPath.decodeNative(), newPath.decodeNative(), cast callback);
	}

	public static function mkdir(path:FilePath, ?recursive:Bool = false, ?mode:FilePermissions, callback:Callback<NoData>):Void {
		if (mode == null)
			mode = @:privateAccess new FilePermissions(511); // 0777
		if (!recursive)
			return w_fs_mkdir(Uv.loop, path.decodeNative(), mode.get_raw(), cast callback);
		var components = path.components;
		var pathBuffer = components.shift();
		function step(error:Error, _):Void {
			if ((error != null && !error.type.match(UVError(asys.uv.UVErrorType.EEXIST))) || components.length == 0)
				return callback(error, null);
			pathBuffer = pathBuffer / components.shift();
			w_fs_mkdir(Uv.loop, pathBuffer.decodeNative(), mode.get_raw(), step);
		}
		w_fs_mkdir(Uv.loop, pathBuffer.decodeNative(), mode.get_raw(), step);
	}

	public static function mkdtemp(prefix:FilePath, callback:Callback<FilePath>):Void {
		w_fs_mkdtemp(Uv.loop, prefix.decodeNative(), (error, path) -> callback(error, error == null ? FilePath.encodeNative(path) : null));
	}

	public static function readdir(path:FilePath, callback:Callback<Array<FilePath>>):Void {
		readdirTypes(path, (error, entries) -> callback(error, error == null ? entries.map(entry -> entry.name) : null));
	}

	public static function readdirTypes(path:FilePath, callback:Callback<Array<neko.uv.DirectoryEntry>>):Void {
		w_fs_scandir(Uv.loop, path.decodeNative(), 0, (error, native) -> callback(error, error == null ? neko.NativeArray.toArray(native) : null));
	}

	public static function readlink(path:FilePath, callback:Callback<FilePath>):Void {
		w_fs_readlink(Uv.loop, path.decodeNative(), (error, path) -> callback(error, error == null ? FilePath.encodeNative(path) : null));
	}

	public static function realpath(path:FilePath, callback:Callback<FilePath>):Void {
		w_fs_realpath(Uv.loop, path.decodeNative(), (error, path) -> callback(error, error == null ? FilePath.encodeNative(path) : null));
	}

	public static function rename(oldPath:FilePath, newPath:FilePath, callback:Callback<NoData>):Void {
		w_fs_rename(Uv.loop, oldPath.decodeNative(), newPath.decodeNative(), cast callback);
	}

	public static function rmdir(path:FilePath, callback:Callback<NoData>):Void {
		w_fs_rmdir(Uv.loop, path.decodeNative(), cast callback);
	}

	public static function stat(path:FilePath, ?followSymLinks:Bool = true, callback:Callback<asys.uv.UVStat>):Void {
		if (followSymLinks)
			w_fs_stat(Uv.loop, path.decodeNative(), (error, stat) -> callback(error, stat));
		else
			w_fs_lstat(Uv.loop, path.decodeNative(), (error, stat) -> callback(error, stat));
	}

	public static function symlink(target:FilePath, path:FilePath, ?type:SymlinkType = SymlinkType.SymlinkDir, callback:Callback<NoData>):Void {
		w_fs_symlink(Uv.loop, target.decodeNative(), path.decodeNative(), type.get_raw(), cast callback);
	}

	// static function truncate(path:FilePath, len:Int, callback:Callback<NoData>):Void;
	public static function unlink(path:FilePath, callback:Callback<NoData>):Void {
		w_fs_unlink(Uv.loop, path.decodeNative(), cast callback);
	}

	public static function utimes(path:FilePath, atime:Date, mtime:Date, callback:Callback<NoData>):Void {
		w_fs_utime(Uv.loop, path.decodeNative(), atime.getTime() / 1000, mtime.getTime() / 1000, cast callback);
	}
}
