class Main {
	public static function main():Void {
		UV.init();
		trace(UV.run(UV.loop, UV.UVRunMode.RunDefault));
	}
}
