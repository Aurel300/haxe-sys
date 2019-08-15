import haxe.io.Bytes;
import sys.io.Process;
import utest.Assert;

class TestBase {
	// contents of resources-ro/hello.txt
	public static var helloString = "hello world
symbols ◊†¶•¬
non-BMP 🐄";
	public static var helloBytes = Bytes.ofString(helloString);

	// contents of resources-ro/binary.bin
	// - contains invalid Unicode, should not be used as string
	public static var binaryBytes = Bytes.ofHex("5554462D3820686572652C20627574207468656E3A2000FFFAFAFAFAF2F2F2F2F200C2A0CCD880E2ED9FBFEDA0800D0A");

	// currently running helpers, see `helperStart` and `helperStop`
	static var helpers:Array<Process> = [];

	public static function uvSetup():Void {
		#if hl
		UV.init();
		#elseif eval
		eval.Uv.init();
		#end
	}

	public static function uvTeardown():Void {
		#if hl
		UV.stop(UV.loop);
		UV.run(UV.loop, RunDefault);
		UV.loop_close(UV.loop);
		#elseif eval
		eval.Uv.stop();
		eval.Uv.run(RunDefault);
		eval.Uv.close();
		#end
	}

	public static function uvRun(?mode:sys.uv.UVRunMode = sys.uv.UVRunMode.RunDefault):Bool {
		return
		#if hl
		UV.run(UV.loop, mode);
		#elseif eval
		eval.Uv.run(mode);
		#end
	}

	public static function helperStart(name:String, ?args:Array<String>):Void {
		var proc = new sys.io.Process("python3", ['test-helpers/$name.py'].concat(args == null ? [] : args));
		helpers.push(proc);
	}

	public static function helperStop():{stdout:Bytes, stderr:Bytes, code:Int} {
		var proc = helpers.shift();
		var code = proc.exitCode();
		var stdout = proc.stdout.readAll();
		var stderr = proc.stderr.readAll();
		proc.close();
		return {stdout: stdout, stderr: stderr, code: code};
	}

	public static function helperTeardown():Void {
		if (helpers.length > 0) {
			Assert.fail("helper script(s) not terminated properly");
			for (helper in helpers)
				helper.close();
			helpers.resize(0);
		}
	}
}
