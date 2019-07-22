class TestBase {
	public static function uvSetup():Void {
		#if hl
		UV.init();
		#elseif eval
		eval.Uv.init();
		#end
	}

	public static function uvTeardown():Void {
		#if hl
		UV.loop_close(UV.loop);
		#elseif eval
		eval.Uv.init();
		#end
	}

	public static function uvRun():Void {
		#if hl
		UV.run(UV.loop, UV.UVRunMode.RunDefault);
		#elseif eval
		eval.Uv.run();
		#end
	}
}
