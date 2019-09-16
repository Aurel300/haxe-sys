package asys;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;
import haxe.io.FilePath;
import asys.io.*;
import hl.Uv;
import hl.uv.Loop;

@:access(haxe.async.Callback)
@:access(haxe.io.FilePath)
@:access(asys.FileAccessMode)
@:access(asys.FileOpenFlags)
@:access(asys.FilePermissions)
@:access(asys.SymlinkType)
@:access(asys.io.File)
class AsyncFileSystem {
	@:hlNative("uv", "w_fs_open") static function w_fs_open(loop:Loop, _:hl.Bytes, _:Int, _:Int, cb:Dynamic->File->Void):Void {}
	@:hlNative("uv", "w_fs_unlink") static function w_fs_unlink(loop:Loop, _:hl.Bytes, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_mkdir") static function w_fs_mkdir(loop:Loop, _:hl.Bytes, _:Int, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_mkdtemp") static function w_fs_mkdtemp(loop:Loop, _:hl.Bytes, cb:Dynamic->hl.Bytes->Void):Void {}
	@:hlNative("uv", "w_fs_rmdir") static function w_fs_rmdir(loop:Loop, _:hl.Bytes, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_scandir") static function w_fs_scandir(loop:Loop, _:hl.Bytes, _:Int, cb:Dynamic->hl.NativeArray<hl.uv.DirectoryEntry>->Void):Void {}
	@:hlNative("uv", "w_fs_stat") static function w_fs_stat(loop:Loop, _:hl.Bytes, cb:Dynamic->asys.uv.UVStat->Void):Void {}
	@:hlNative("uv", "w_fs_lstat") static function w_fs_lstat(loop:Loop, _:hl.Bytes, cb:Dynamic->asys.uv.UVStat->Void):Void {}
	@:hlNative("uv", "w_fs_rename") static function w_fs_rename(loop:Loop, _:hl.Bytes, _:hl.Bytes, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_access") static function w_fs_access(loop:Loop, _:hl.Bytes, _:Int, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_chmod") static function w_fs_chmod(loop:Loop, _:hl.Bytes, _:Int, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_utime") static function w_fs_utime(loop:Loop, _:hl.Bytes, _:Float, _:Float, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_link") static function w_fs_link(loop:Loop, _:hl.Bytes, _:hl.Bytes, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_symlink") static function w_fs_symlink(loop:Loop, _:hl.Bytes, _:hl.Bytes, _:Int, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_readlink") static function w_fs_readlink(loop:Loop, _:hl.Bytes, cb:Dynamic->hl.Bytes->Void):Void {}
	@:hlNative("uv", "w_fs_realpath") static function w_fs_realpath(loop:Loop, _:hl.Bytes, cb:Dynamic->hl.Bytes->Void):Void {}
	@:hlNative("uv", "w_fs_chown") static function w_fs_chown(loop:Loop, _:hl.Bytes, _:Int, _:Int, cb:Dynamic->Void):Void {}

	// sys.FileSystem-like functions
	public static function access(path:FilePath, ?mode:FileAccessMode = FileAccessMode.Ok, callback:Callback<NoData>):Void {
		w_fs_access(Uv.loop, path.decodeHl(), mode.get_raw(), callback.toUVNoData());
	}

	public static function chmod(path:FilePath, mode:FilePermissions, ?followSymLinks:Bool = true, callback:Callback<NoData>):Void {
		if (followSymLinks)
			w_fs_chmod(Uv.loop, path.decodeHl(), mode.get_raw(), callback.toUVNoData());
		else
			throw "not implemented";
		// w_fs_lchmod(Uv.loop, path.decodeHl(), mode.get_raw(), callback.toUVNoData());
	}

	public static function chown(path:FilePath, uid:Int, gid:Int, ?followSymLinks:Bool = true, callback:Callback<NoData>):Void {
		if (followSymLinks)
			w_fs_chown(Uv.loop, path.decodeHl(), uid, gid, callback.toUVNoData());
		else
			throw "not implemented";
		// w_fs_lchown(Uv.loop, path.decodeHl(), uid, gid, callback.toUVNoData());
	}

	// static function copyFile(src:FilePath, dest:FilePath, ?flags:FileCopyFlags, callback:Callback<NoData>):Void;
	public static function exists(path:FilePath, callback:Callback<Bool>):Void {
		access(path, (error) -> callback(error == null));
	}

	public static function link(existingPath:FilePath, newPath:FilePath, callback:Callback<NoData>):Void {
		w_fs_link(Uv.loop, existingPath.decodeHl(), newPath.decodeHl(), callback.toUVNoData());
	}

	public static function mkdir(path:FilePath, ?recursive:Bool = false, ?mode:FilePermissions, callback:Callback<NoData>):Void {
		if (mode == null)
			mode = @:privateAccess new FilePermissions(511); // 0777
		if (!recursive)
			return w_fs_mkdir(Uv.loop, path.decodeHl(), mode.get_raw(), callback.toUVNoData());
		var components = path.components;
		var pathBuffer = components.shift();
		function step(error:Error):Void {
			if ((error != null && !error.type.match(UVError(asys.uv.UVErrorType.EEXIST))) || components.length == 0)
				return callback(error, null);
			pathBuffer = pathBuffer / components.shift();
			w_fs_mkdir(Uv.loop, pathBuffer.decodeHl(), mode.get_raw(), step);
		}
		w_fs_mkdir(Uv.loop, pathBuffer.decodeHl(), mode.get_raw(), step);
	}

	public static function mkdtemp(prefix:FilePath, callback:Callback<FilePath>):Void {
		w_fs_mkdtemp(Uv.loop, prefix.decodeHl(), (error, path) -> callback(error, error == null ? FilePath.encodeHl(path) : null));
	}

	public static function readdir(path:FilePath, callback:Callback<Array<FilePath>>):Void {
		readdirTypes(path, (error, entries) -> callback(error, error == null ? entries.map(entry -> entry.name) : null));
	}

	public static function readdirTypes(path:FilePath, callback:Callback<Array<DirectoryEntry>>):Void {
		w_fs_scandir(Uv.loop, path.decodeHl(), 0, (error, native) -> callback(error, error == null ? [for (i in 0...native.length) native[i]] : null));
	}

	public static function readlink(path:FilePath, callback:Callback<FilePath>):Void {
		w_fs_readlink(Uv.loop, path.decodeHl(), (error, path) -> callback(error, error == null ? FilePath.encodeHl(path) : null));
	}

	public static function realpath(path:FilePath, callback:Callback<FilePath>):Void {
		w_fs_realpath(Uv.loop, path.decodeHl(), (error, path) -> callback(error, error == null ? FilePath.encodeHl(path) : null));
	}

	public static function rename(oldPath:FilePath, newPath:FilePath, callback:Callback<NoData>):Void {
		w_fs_rename(Uv.loop, oldPath.decodeHl(), newPath.decodeHl(), callback.toUVNoData());
	}

	public static function rmdir(path:FilePath, callback:Callback<NoData>):Void {
		w_fs_rmdir(Uv.loop, path.decodeHl(), callback.toUVNoData());
	}

	public static function stat(path:FilePath, ?followSymLinks:Bool = true, callback:Callback<asys.uv.UVStat>):Void {
		if (followSymLinks)
			w_fs_stat(Uv.loop, path.decodeHl(), (error, stat) -> callback(error, stat));
		else
			w_fs_lstat(Uv.loop, path.decodeHl(), (error, stat) -> callback(error, stat));
	}

	public static function symlink(target:FilePath, path:FilePath, ?type:SymlinkType = SymlinkType.SymlinkDir, callback:Callback<NoData>):Void {
		w_fs_symlink(Uv.loop, target.decodeHl(), path.decodeHl(), type.get_raw(), callback.toUVNoData());
	}

	// static function truncate(path:FilePath, len:Int, callback:Callback<NoData>):Void;
	public static function unlink(path:FilePath, callback:Callback<NoData>):Void {
		w_fs_unlink(Uv.loop, path.decodeHl(), callback.toUVNoData());
	}

	public static function utimes(path:FilePath, atime:Date, mtime:Date, callback:Callback<NoData>):Void {
		w_fs_utime(Uv.loop, path.decodeHl(), atime.getTime() / 1000, mtime.getTime() / 1000, callback.toUVNoData());
	}
}
