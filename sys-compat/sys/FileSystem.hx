package sys;

class FileSystem {
	public static inline function absolutePath(path:String):String throw "?"; // should be implemented in haxe.io.Path

	public static inline function createDirectory(path:String):Void return asys.FileSystem.mkdir(path, true);

	public static inline function deleteDirectory(path:String):Void return asys.FileSystem.rmdir(path);

	public static inline function deleteFile(path:String):Void return asys.FileSystem.unlink(path);

	public static inline function exists(path:String):Bool return asys.FileSystem.exists(path);

	public static inline function fullPath(path:String):FilePath return asys.FileSystem.realpath(path);

	public static inline function isDirectory(path:String):Bool return asys.FileSystem.stat(path).isDirectory();

	public static inline function readDirectory(path:String):Array<String> return asys.FileSystem.readdir(path);

	public static inline function rename(path:String, newPath:String):Void asys.FileSystem.rename(path, newPath);

	public static inline function stat(path:String):FileStat return asys.FileSystem.stat(path);
}
