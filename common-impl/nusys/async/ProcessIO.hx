package nusys.async;

enum ProcessIO {
	Pipe(readable:Bool, writable:Bool, ?pipe:nusys.io.Pipe);
	// Ipc;
	Ignore;
	Inherit;
	// Stream(_);
	// Fd(_);
}
