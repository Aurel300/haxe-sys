package nusys.async;

enum ProcessIO {
	Pipe(readable:Bool, writable:Bool, ?pipe:nusys.async.net.Socket);
	// Ipc;
	Ignore;
	Inherit;
	// Stream(_);
	// Fd(_);
}
