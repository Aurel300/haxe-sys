class Main {
	public static function main():Void {
		UV.init();
		nusys.FileSystem.createDirectory("hello/world/example");
		nusys.FileSystem.createDirectory("hello/haxe");
		nusys.FileSystem.createDirectory("hello/haxe/sys/apis");
		nusys.FileSystem.createDirectory("hello/");
		nusys.FileSystem.createDirectory("hello");

		nusys.async.FileSystem.mkdir("async/hello/world/example/also", true, (error) -> trace("error?", error));
		UV.run(UV.loop, UV.UVRunMode.RunDefault);
	}
}
