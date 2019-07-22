package nusys;

import haxe.io.FilePath;
import sys.*;

class FileSystem {
	extern public static function access(path:FilePath, ?mode:FileAccessMode = FileAccessMode.Ok):Void;
	extern public static function chmod(path:FilePath, mode:FileMode, ?followSymLinks:Bool = true):Void;
	extern public static function chown(path:FilePath, uid:Int, gid:Int, ?followSymLinks:Bool = true):Void;
	extern public static function exists(path:FilePath):Bool;
	extern public static function link(existingPath:FilePath, newPath:FilePath):Void;
	extern static function mkdir_native(path:FilePath, mode:FileMode):Void;
	public static function mkdir(path:FilePath, ?recursive:Bool = false, ?mode:FileMode = 511 /* 0777 */):Void {
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
			} catch (e:Dynamic/*Error*/) {
				//if (e.type.match(UVError(UV.UVErrorType.EEXIST)))
				//	continue;
				throw e;
			}
		}
	}
	extern public static function mkdtemp(prefix:FilePath):FilePath;
	/*public static function readdir(path:FilePath):Array<FilePath> {
		return readdirTypes(path).map(entry -> entry.name);
	}*/
	//extern public static function readdirTypes(path:FilePath):Array<DirectoryEntry>;
	extern public static function readlink(path:FilePath):FilePath;
	extern public static function realpath(path:FilePath):FilePath;
	extern public static function rename(oldPath:FilePath, newPath:FilePath):Void;
	extern public static function rmdir(path:FilePath):Void;
	//extern public static function stat(path:FilePath, ?followSymLinks:Bool = true):FileStat;
	extern public static function symlink(target:FilePath, path:FilePath, ?type:SymlinkType = SymlinkType.SymlinkDir):Void;
	//extern public static function truncate(path:FilePath, len:Int):Void;
	extern public static function unlink(path:FilePath):Void;
	extern public static function utimes_native(path:FilePath, atime:Float, mtime:Float):Void;
	public static function utimes(path:FilePath, atime:Date, mtime:Date):Void {
		utimes_native(path, atime.getTime(), mtime.getTime());
	}
	//extern public static function watch(filename:FilePath, ?persistent:Bool = true, ?recursive:Bool = false):FileWatcher;

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
