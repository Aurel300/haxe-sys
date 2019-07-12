package nusys.async;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;
import haxe.io.FilePath;
import sys.*;

@:access(haxe.async.Callback)
@:access(haxe.io.FilePath)
@:access(sys.FileAccessMode)
@:access(sys.FileOpenFlags)
@:access(sys.FileMode)
@:access(sys.SymlinkType)
@:access(nusys.io.File)
class FileSystem {
	// sys.FileSystem-like functions
	public static function access(path:FilePath, ?mode:FileAccessMode = FileAccessMode.Ok, callback:Callback<NoData>):Void
		UV.fs_access(UV.loop, path.decodeHl(), mode.get_raw(), callback.toUVNoData());

	public static function chmod(path:FilePath, mode:FileMode, ?followSymLinks:Bool = true, callback:Callback<NoData>):Void {
		if (followSymLinks)
			UV.fs_chmod(UV.loop, path.decodeHl(), mode.get_raw(), callback.toUVNoData());
		else
			throw "not implemented";
		// UV.fs_lchmod(UV.loop, path.decodeHl(), mode.get_raw(), callback.toUVNoData());
	}

	public static function chown(path:FilePath, uid:Int, gid:Int, ?followSymLinks:Bool = true, callback:Callback<NoData>):Void {
		if (followSymLinks)
			UV.fs_chown(UV.loop, path.decodeHl(), uid, gid, callback.toUVNoData());
		else
			throw "not implemented";
		// UV.fs_lchown(UV.loop, path.decodeHl(), uid, gid, callback.toUVNoData());
	}

	// static function copyFile(src:FilePath, dest:FilePath, ?flags:FileCopyFlags, callback:Callback<NoData>):Void;
	public static function exists(path:FilePath, callback:Callback<Bool>):Void
		access(path, (error) -> callback(error == null));

	public static function link(existingPath:FilePath, newPath:FilePath, callback:Callback<NoData>):Void
		UV.fs_link(UV.loop, existingPath.decodeHl(), newPath.decodeHl(), callback.toUVNoData());

	public static function mkdir(path:FilePath, ?recursive:Bool = false, ?mode:FileMode = 511 /* 0777 */, callback:Callback<NoData>):Void {
		if (!recursive)
			return UV.fs_mkdir(UV.loop, path.decodeHl(), mode.get_raw(), callback.toUVNoData());
		var components = path.components;
		var pathBuffer = components.shift();
		function step(error:Error):Void {
			if ((error != null && !error.type.match(UVError(UV.UVErrorType.EEXIST))) || components.length == 0)
				return callback(error, null);
			pathBuffer = pathBuffer / components.shift();
			UV.fs_mkdir(UV.loop, pathBuffer.decodeHl(), mode.get_raw(), step);
		}
		UV.fs_mkdir(UV.loop, pathBuffer.decodeHl(), mode.get_raw(), step);
	}

	public static function mkdtemp(prefix:FilePath, callback:Callback<FilePath>):Void
		UV.fs_mkdtemp(UV.loop, prefix.decodeHl(), (error, path) -> callback(error, error == null ? FilePath.encodeHl(path) : null));

	public static function readdir(path:FilePath, callback:Callback<Array<FilePath>>):Void
		readdirTypes(path, (error, entries) -> callback(error, error == null ? entries.map(entry -> entry.name) : null));

	// TODO: flags?
	public static function readdirTypes(path:FilePath, callback:Callback<Array<DirectoryEntry>>):Void
		UV.fs_scandir(UV.loop, path.decodeHl(), 0, (error, native) -> callback(error, error == null ? [for (i in 0...native.length) native[i]] : null));

	public static function readlink(path:FilePath, callback:Callback<FilePath>):Void
		UV.fs_readlink(UV.loop, path.decodeHl(), (error, path) -> callback(error, error == null ? FilePath.encodeHl(path) : null));

	public static function realpath(path:FilePath, callback:Callback<FilePath>):Void
		UV.fs_realpath(UV.loop, path.decodeHl(), (error, path) -> callback(error, error == null ? FilePath.encodeHl(path) : null));

	public static function rename(oldPath:FilePath, newPath:FilePath, callback:Callback<NoData>):Void
		UV.fs_rename(UV.loop, oldPath.decodeHl(), newPath.decodeHl(), callback.toUVNoData());

	public static function rmdir(path:FilePath, callback:Callback<NoData>):Void
		UV.fs_rmdir(UV.loop, path.decodeHl(), callback.toUVNoData());

	public static function stat(path:FilePath, ?followSymLinks:Bool = true, callback:Callback<UV.UVStat /*FileStat*/>):Void {
		if (followSymLinks)
			UV.fs_stat(UV.loop, path.decodeHl(), (error, stat) -> callback(error, stat));
		else
			UV.fs_lstat(UV.loop, path.decodeHl(), (error, stat) -> callback(error, stat));
	}

	public static function symlink(target:FilePath, path:FilePath, ?type:SymlinkType = SymlinkType.SymlinkDir, callback:Callback<NoData>):Void
		UV.fs_symlink(UV.loop, target.decodeHl(), path.decodeHl(), type.get_raw(), callback.toUVNoData());

	// static function truncate(path:FilePath, len:Int, callback:Callback<NoData>):Void;
	public static function unlink(path:FilePath, callback:Callback<NoData>):Void
		UV.fs_unlink(UV.loop, path.decodeHl(), callback.toUVNoData());

	public static function utimes(path:FilePath, atime:Date, mtime:Date, callback:Callback<NoData>):Void
		UV.fs_utime(UV.loop, path.decodeHl(), atime.getTime() / 1000, mtime.getTime() / 1000, callback.toUVNoData());

	//// sys.io.File-like functions
	// static function appendFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode, callback:Callback<NoData>):Void;
	// static function open(path:FilePath, ?flags:FileOpenFlags, ?mode:FileMode, ?binary:Bool = true, callback:Callback<sys.io.File>):Void;
	// static function readFile(path:FilePath, ?flags:FileOpenFlags, callback:Callback<Bytes>):Void;
	// static function writeFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode, callback:Callback<NoData>):Void;
}
