package sys;

import haxe.Error;
import haxe.NoData;
import haxe.async.Signal;
import sys.FileWatcherEvent;

typedef FileWatcherNative =
	#if hl
	UV.UVFsEvent;
	#elseif eval
	eval.uv.FileWatcher;
	#else
	#error "file watcher not supported on this platform"
	#end

class FileWatcher {
	public final changeSignal = new Signal<FileWatcherEvent>();
	public final closeSignal = new Signal<NoData>();
	public final errorSignal = new Signal<Error>();

	private var handle:FileWatcherNative;

	private function new(handle:FileWatcherNative) {
		this.handle = handle;
	}

	public function close():Void {
		#if hl
		UV.fs_event_stop(handle, (err) -> {
		#elseif eval
		handle.close((err, _) -> {
		#end
			if (err != null)
				errorSignal.emit(err);
			closeSignal.emit(new NoData());
		});
	}
}
