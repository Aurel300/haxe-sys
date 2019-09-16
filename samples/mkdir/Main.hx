class Main {
	public static function main():Void {
		UV.init();
		asys.FileSystem.createDirectory("hello/world/example");
		asys.FileSystem.createDirectory("hello/haxe");
		asys.FileSystem.createDirectory("hello/haxe/sys/apis");
		asys.FileSystem.createDirectory("hello/");
		asys.FileSystem.createDirectory("hello");

		asys.AsyncFileSystem.mkdir("async/hello/world/example/also", true, (error) -> trace("error?", error));
		UV.run(UV.loop, UV.UVRunMode.RunDefault);
	}
}
