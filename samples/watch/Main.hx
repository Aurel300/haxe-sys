class Main {
	public static function main():Void {
		UV.init();
		var watcher = asys.FileSystem.watch(".", true, true);
		watcher.errorSignal.on(error -> trace("error", error));
		watcher.changeSignal.on(change -> trace("change", change));
		trace(UV.run(UV.loop, UV.UVRunMode.RunDefault));
	}
}
