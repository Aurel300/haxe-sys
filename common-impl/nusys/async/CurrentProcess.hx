package nusys.async;

import haxe.async.*;
import nusys.async.net.Socket;
import nusys.io.*;

/**
	Methods to control the current process and IPC interaction with the parent
	process.
**/
class CurrentProcess {
	/**
		Emitted when a message is received over IPC. `initIpc` must be called first
		to initialise the IPC channel.
	**/
	public static final messageSignal:Signal<IpcMessage> = new ArraySignal();

	static var ipc:Socket;
	static var ipcOut:IpcSerializer;
	static var ipcIn:IpcUnserializer;

	/**
		Initialise the IPC channel on the given file descriptor `fd`. This should
		only be used when the current process was spawned with `Process.spawn` from
		another Haxe process. `fd` should correspond to the index of the `Ipc`
		entry in `options.stdio`.
	**/
	public static function initIpc(fd:Int):Void {
		if (ipc != null)
			throw "IPC already initialised";
		ipc = Socket.create();
		ipcOut = @:privateAccess new IpcSerializer(ipc);
		ipcIn = @:privateAccess new IpcUnserializer(ipc);
		ipc.connectFd(true, fd);
		ipc.errorSignal.on(err -> trace("IPC error", err));
		ipcIn.messageSignal.on(message -> messageSignal.emit(message));
	}

	/**
		Sends a message over IPC. `initIpc` must be called first to initialise the
		IPC channel.
	**/
	public static function send(message:IpcMessage):Void {
		if (ipc == null)
			throw "IPC not connected";
		ipcOut.write(message);
	}

	public static function initUv():Void {
		#if eval
		eval.Uv.init();
		#else
		throw "!";
		#end
	}

	public static function runUv(?mode:sys.uv.UVRunMode = RunDefault):Bool {
		#if eval
		return eval.Uv.run(mode);
		#else
		throw "!";
		#end
	}

	public static function stopUv():Void {
		#if eval
		eval.Uv.stop();
		eval.Uv.run(RunDefault);
		eval.Uv.close();
		#else
		throw "!";
		#end
	}
}
