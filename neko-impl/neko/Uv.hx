package neko;

import haxe.Error;
import neko.uv.*;

class Uv {
	static var glue_register:(neko.NativeArray<Dynamic>)->Void = neko.Lib.load("uv", "glue_register_dyn", 1);

	public static var loop:Loop;

	public static function init():Void {
		if (loop == null)
			glue_register(neko.NativeArray.ofArrayRef(([
				(errno:Int) -> new Error(haxe.ErrorType.UVError(cast errno)),
				asys.uv.UVStat.new,
				neko.uv.DirectoryEntry.new,
				asys.net.Address.Ipv4,
				(bytes:neko.NativeString) -> asys.net.Address.Ipv6(haxe.io.Bytes.ofData(bytes)),
				(address:asys.net.Address, port:Int) -> asys.net.SocketAddress.Network(address, port),
				neko.uv.Pipe.PipeAccept.Socket,
				neko.uv.Pipe.PipeAccept.Pipe
			]:Array<Dynamic>)));
		loop = new Loop();
	}

	public static function run(mode:asys.uv.UVRunMode):Bool {
		return loop.run(mode);
	}

	public static function stop():Void {
		loop.stop();
	}

	public static function close():Void {
		loop.close();
	}
}
