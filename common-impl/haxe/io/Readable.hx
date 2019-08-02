package haxe.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.ds.List;

class Readable implements IReadable {
	public final dataSignal:Signal<Bytes>;
	public final endSignal:Signal<NoData>;
	public final errorSignal:Signal<Error> = new ArraySignal<Error>();
	public final pauseSignal:Signal<NoData> = new ArraySignal<NoData>();
	public final resumeSignal:Signal<NoData> = new ArraySignal<NoData>();

	public var highWaterMark = 8192;
	public var bufferLength(default, null) = 0;
	public var flowing(default, null) = false;
	public var done(default, null) = false;

	var buffer = new List<Bytes>();
	var deferred:haxe.Timer;
	var willEof = false;

	function new(?highWaterMark:Int = 8192) {
		this.highWaterMark = highWaterMark;
		var dataSignal = new WrappedSignal<Bytes>();
		dataSignal.changeSignal.on(() -> {
			if (dataSignal.listenerCount > 0)
				resume();
		});
		this.dataSignal = dataSignal;
		var endSignal = new WrappedSignal<NoData>();
		endSignal.changeSignal.on(() -> {
			if (endSignal.listenerCount > 0)
				resume();
		});
		this.endSignal = endSignal;
	}

	inline function shouldFlow():Bool {
		return !done && (dataSignal.listenerCount > 0 || endSignal.listenerCount > 0);
	}

	// internal
	function process():Void {
		deferred = null;
		if (!shouldFlow())
			flowing = false;
		if (!flowing)
			return;

		// pre-emptive read until HWM
		if (!willEof && !done)
			while (bufferLength < highWaterMark) {
				switch (internalRead(highWaterMark - bufferLength)) {
					case None:
						break;
					case Data(chunks, eof):
						for (chunk in chunks)
							push(chunk);
						if (eof) {
							willEof = true;
							break;
						}
				}
			}

		// emit data
		while (buffer.length > 0 && flowing && shouldFlow())
			dataSignal.emit(pop());

		if (willEof) {
			endSignal.emit(new NoData());
			flowing = false;
			done = true;
			return;
		}

		if (!shouldFlow())
			flowing = false;
		else
			scheduleProcess();
	}

	inline function scheduleProcess():Void {
		if (deferred == null)
			deferred = Defer.nextTick(process);
	}

	function asyncRead(chunks:Array<Bytes>, eof:Bool):Void {
		if (done || willEof)
			throw "stream already done";
		if (chunks != null)
			for (chunk in chunks)
				push(chunk);
		if (eof)
			willEof = true;
		if (chunks != null || eof)
			scheduleProcess();
	}

	function pop():Bytes {
		if (done)
			throw "stream already done";
		var chunk = buffer.pop();
		bufferLength -= chunk.length;
		return chunk;
	}

	// override by implementing classes
	function internalRead(remaining:Int):ReadResult {
		throw "not implemented";
	}

	// for use by implementing classes
	function push(chunk:Bytes):Bool {
		if (done)
			throw "stream already done";
		buffer.add(chunk);
		bufferLength += chunk.length;
		return bufferLength < highWaterMark;
	}

	// for consumers
	public function resume():Void {
		if (done)
			return;
		if (!flowing) {
			resumeSignal.emit(new NoData());
			flowing = true;
			scheduleProcess();
		}
	}

	public function pause():Void {
		if (done)
			return;
		if (flowing) {
			pauseSignal.emit(new NoData());
			flowing = false;
		}
	}

	public function pipe(to:IWritable):Void {
		throw "!";
	}
}

enum ReadResult {
	None;
	Data(chunks:Array<Bytes>, eof:Bool);
}
