import haxe.io.Bytes;
import nusys.io.*;
import nusys.async.*;
import utest.Assert;

class TestBase {
	static var helpers:Map<Process, {?exit:ProcessExit}> = [];

	public static function uvSetup():Void {
		#if hl
		UV.init();
		#elseif eval
		eval.Uv.init();
		#end
	}

	public static function uvTeardown():Void {
		helperTeardown();
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

	/**
		The helper script should be in `test-helpers/<current target>`:

		- `eval` - `test-helpers/eval/<name>.hxml`; will be executed with the hxml
			and `--run <Name>` appended in order to support passing arguments.
	**/
	public static function helperStart(name:String, ?args:Array<String>, ?options:nusys.async.Process.ProcessSpawnOptions):Process {
		if (args == null)
			args = [];
		var proc:Process;
		#if eval
		args.unshift(name.charAt(0).toUpperCase() + name.substr(1));
		args.unshift("--run");
		args.unshift('test-helpers/eval/$name.hxml');
		name = "/DevProjects/Repos/haxe/haxe";
		#else
		throw "unsupported platform for helperStart";
		#end
		proc = Process.spawn(name, args, options);
		helpers[proc] = {};
		proc.exitSignal.on(exit -> helpers[proc].exit = exit);
		return proc;
	}

	public static function helperTeardown():Void {
		/*
		var anyFail = false;
		for (proc => res in helpers) {
			if (res.exit == null) {
				proc.kill();
				proc.close();
				anyFail = true;
			}
		}
		helpers = [];
		if (anyFail)
			Assert.fail("helper script(s) not terminated properly");
		*/
	}
}
