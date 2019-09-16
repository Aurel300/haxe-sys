class Main {
	public static function main():Void {
		UV.init();
		trace(asys.FileSystem.fullPath("/usr/local/bin/xz"));
		trace(UV.run(UV.loop, UV.UVRunMode.RunDefault));
	}
}
