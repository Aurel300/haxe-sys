package nusys.async;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.io.*;
import nusys.async.net.Socket;
import nusys.io.*;

/**
	Options for spawning a process. See `Process.spawn`.
**/
typedef ProcessSpawnOptions = {
	?cwd:FilePath,
	?env:Map<String, String>,
	?argv0:String,
	?stdio:Array<ProcessIO>,
	?detached:Bool,
	?uid:Int,
	?gid:Int,
	// ?shell:?,
	?windowsVerbatimArguments:Bool,
	?windowsHide:Bool
};

/**
	Class representing a spawned process.
**/
extern class Process {
	/**
		Execute the given `command` with `args` (none by default). `options` can be
		specified to change the way the process is spawned.

		`options.stdio` is an optional array of `ProcessIO` specifications which
		can be used to define the file descriptors for the new process:

		- `Ignore` - skip the current position. No stream or pipe will be open for
			this index.
		- `Inherit` - inherit the corresponding file descriptor from the current
			process. Shares standard input, standard output, and standard error in
			index 0, 1, and 2, respectively. In index 3 or higher, `Inherit` has the
			same effect as `Ignore`.
		- `Pipe(readable, writable, ?pipe)` - create or use a pipe. `readable` and
			`writable` specify whether the pipe will be readable and writable from
			the point of view of the spawned process. If `pipe` is given, it is used
			directly, otherwise a new pipe is created.
		- `Ipc` - create an IPC (inter-process comunication) pipe. Only one may be
			specified in `options.stdio`. This special pipe will not have an entry in
			the `stdio` array of the resulting process; instead, messages can be sent
			using the `send` method, and received over `messageSignal`. IPC pipes
			allow sending and receiving structured Haxe data, as well as connected
			sockets and pipes.

		Pipes are made available in the `stdio` array afther the process is
		spawned. Standard file descriptors have their own variables:

		- `stdin` - set to point to a pipe in index 0, if it exists and is
			read-only for the spawned process.
		- `stdout` - set to point to a pipe in index 1, if it exists and is
			write-only for the spawned process.
		- `stderr` - set to point to a pipe in index 2, if it exists and is
			write-only for the spawned process.

		If `options.stdio` is not given,
		`[Pipe(true, false), Pipe(false, true), Pipe(false, true)]` is used as a
		default.

		@param options.cwd Path to the working directory. Defaults to the current
			working directory if not given.
		@param options.env Environment variables. Defaults to the environment
			variables of the current process if not given.
		@param options.argv0 First entry in the `argv` array for the spawned
			process. Defaults to `command` if not given.
		@param options.stdio Array of `ProcessIO` specifications, see above.
		@param options.detached When `true`, creates a detached process which can
			continue running after the current process exits. Note that `unref` must
			be called on the spawned process otherwise the event loop of the current
			process is kept allive.
		@param options.uid User identifier.
		@param options.gid Group identifier.
		@param options.windowsVerbatimArguments (Windows only.) Do not perform
			automatic quoting or escaping of arguments.
		@param options.windowsHide (Windows only.) Automatically hide the window of
			the spawned process.
	**/
	static function spawn(command:String, ?args:Array<String>, ?options:ProcessSpawnOptions):Process;

	/**
		Emitted when `this` process and all of its pipes are closed.
	**/
	final closeSignal:Signal<NoData>;

	// final disconnectSignal:Signal<NoData>; // IPC

	/**
		Emitted when an error occurs during communication with `this` process.
	**/
	final errorSignal:Signal<Error>;

	/**
		Emitted when `this` process exits, potentially due to a signal.
	**/
	final exitSignal:Signal<ProcessExit>;

	/**
		Emitted when a message is received over IPC. The process must be created
		with an `Ipc` entry in `options.stdio`; see `Process.spawn`.
	**/
	var messageSignal(default, null):Signal<IpcMessage>;

	// var connected:Bool; // IPC
	var killed:Bool;

	private function get_pid():Int;

	/**
		Process identifier of `this` process. A PID uniquely identifies a process
		on its host machine for the duration of its lifetime.
	**/
	var pid(get, never):Int;

	/**
		Standard input. May be `null` - see `options.stdio` in `spawn`.
	**/
	var stdin:IWritable;

	/**
		Standard output. May be `null` - see `options.stdio` in `spawn`.
	**/
	var stdout:IReadable;

	/**
		Standard error. May be `null` - see `options.stdio` in `spawn`.
	**/
	var stderr:IReadable;

	/**
		Pipes created between the current (host) process and `this` (spawned)
		process. The order corresponds to the `ProcessIO` specifiers in
		`options.stdio` in `spawn`. This array can be used to access non-standard
		pipes, i.e. file descriptors 3 and higher, as well as file descriptors 0-2
		with non-standard read/write access.
	**/
	var stdio:Array<Socket>;

	// function disconnect():Void; // IPC

	/**
		Send a signal to `this` process.
	**/
	function kill(?signal:Int = 7):Void;

	/**
		Close `this` process handle and all pipes in `stdio`.
	**/
	function close(?cb:Callback<NoData>):Void;

	/**
		Send `data` to the process over the IPC channel. The process must be
		created with an `Ipc` entry in `options.stdio`; see `Process.spawn`.
	**/
	function send(message:IpcMessage):Void;

	function ref():Void;
	function unref():Void;
}