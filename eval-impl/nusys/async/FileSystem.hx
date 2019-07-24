package nusys.async;

import haxe.NoData;
import haxe.async.Callback;
import haxe.io.FilePath;
import sys.FileAccessMode;

class FileSystem {
	extern public static function access(path:FilePath, ?mode:FileAccessMode = FileAccessMode.Ok, cb:Callback<NoData>):Void;
	extern public static function exists(path:FilePath, cb:Callback<Bool>):Void;
	public static function readdir(path:FilePath, callback:Callback<Array<FilePath>>):Void
		readdirTypes(path, (error, entries) -> callback(error, error == null ? entries.map(entry -> entry.name) : null));
	extern public static function readdirTypes(path:FilePath, callback:Callback<Array<eval.uv.DirectoryEntry>>):Void;
}
