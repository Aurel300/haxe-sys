package hl;

import haxe.Error;
import hl.uv.*;

class Uv {
	@:hlNative("uv", "glue_register") static function glue_register(
		c_error:Int->Dynamic,
		c_fs_stat:(Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int)->Dynamic,
		c_fs_dirent:(hl.Bytes, asys.uv.UVDirentType)->Dynamic,
		c_addrinfo_ipv4:Int->Dynamic,
		c_addrinfo_ipv6:hl.Bytes->Dynamic,
		c_addrport:(Dynamic, Int)->Dynamic,
		c_pipe_accept_socket:Socket->Dynamic,
		c_pipe_accept_pipe:Pipe->Dynamic
	):Void {}

	public static var loop:Loop;

	public static function init():Void {
		if (loop == null)
			glue_register(
				(errno) -> new Error(haxe.ErrorType.UVError(cast errno)),
				asys.uv.UVStat.new,
				hl.uv.DirectoryEntry.new,
				asys.net.Address.Ipv4,
				bytes -> asys.net.Address.Ipv6(bytes.toBytes(16)),
				(address:Dynamic, port:Int) -> asys.net.SocketAddress.Network(address, port),
				hl.uv.Pipe.PipeAccept.Socket,
				hl.uv.Pipe.PipeAccept.Pipe
			);
		loop = new Loop();
	}

	public static function run(mode:asys.uv.UVRunMode):Bool {
		return loop.run(mode);
	}

	public static function stop():Void {
		loop.stop();
	}

	public static function close():Void {
		// TODO: cb
		loop.close();
	}
}
