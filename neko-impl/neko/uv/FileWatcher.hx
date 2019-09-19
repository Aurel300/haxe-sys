package neko.uv;

import haxe.NoData;
import haxe.async.*;
import haxe.io.FilePath;

@:access(haxe.io.FilePath)
abstract FileWatcher(Dynamic) {
	static var w_fs_event_start:(Loop, neko.NativeString, Bool, (Dynamic, neko.NativeString, asys.uv.UVFsEventType)->Void)->Dynamic = neko.Lib.load("uv", "w_fs_event_start", 4);
	static var w_fs_event_stop:(Dynamic, cb:Dynamic->Void)->Void = neko.Lib.load("uv", "w_fs_event_stop", 2);
	static var w_fs_event_handle:(Dynamic)->Handle = neko.Lib.load("uv", "w_fs_event_handle", 1);

	public inline function new(path:FilePath, recursive:Bool, cb:Callback<asys.FileWatcherEvent>) {
		this = w_fs_event_start(Uv.loop, path.decodeNative(), recursive, (error, path, event) -> {
			if (error != null)
				cb(error, null);
			else
				cb(null, switch (event) {
					case asys.uv.UVFsEventType.Rename:
						asys.FileWatcherEvent.Rename(FilePath.encodeNative(path));
					case asys.uv.UVFsEventType.Change:
						asys.FileWatcherEvent.Change(FilePath.encodeNative(path));
					case _:
						asys.FileWatcherEvent.RenameChange(FilePath.encodeNative(path));
				});
		});
	}

	public inline function close(cb:Callback<haxe.NoData>):Void {
		w_fs_event_stop(this, error -> cb(error, new NoData()));
	}

	public inline function ref():Void {
		asHandle().ref();
	}

	public inline function unref():Void {
		asHandle().unref();
	}

	public inline function asHandle():Handle {
		return w_fs_event_handle(this);
	}
}
