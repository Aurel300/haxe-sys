package nusys.async;

import haxe.io.FilePath;
import sys.FileAccessMode;

extern class FileSystem {
	public static function access(path:FilePath, ?mode:FileAccessMode = FileAccessMode.Ok, cb:(error:String, nodata:haxe.NoData)->Void):Void;
}
