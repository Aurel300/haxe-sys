package test;

import utest.Async;

class TestAsyncFileSystem extends Test {
	override function setup() {
		TestBase.uvSetup();
	}

	override function teardown() {
		TestBase.uvTeardown();
	}

	function testAsync(async:Async) {
		var calls = 0;
		var callsExpected = 0;
		function callOnce<T>(cb:haxe.async.Callback<T>):haxe.async.Callback<T> {
			callsExpected++;
			return (error, data) -> {
				if (error == null)
					cb(error, data);
				else
					utest.Assert.fail('unexpected error in callback: $error');
				if (++calls == callsExpected)
					async.done();
			};
		}

		nusys.async.FileSystem.exists("resources-ro/hello.txt", callOnce((error, exists) -> t(exists)));
		nusys.async.FileSystem.exists("resources-ro/non-existent-file", callOnce((error, exists) -> f(exists)));
		nusys.async.FileSystem.readdir("resources-ro", callOnce((error, names) -> aeq(names, ["hello.txt", "binary.bin"])));

		eq(calls, 0);
		TestBase.uvRun();
		eq(calls, callsExpected);
	}

	@:timeout(3000)
	function testWatcher(async:Async) {
		var dir = "resources-rw/watch";
		sys.FileSystem.createDirectory(dir);
		var events = [];

		var watcher = nusys.FileSystem.watch(dir, true, true);
		watcher.closeSignal.on(_ -> {
			async.done();
			sys.FileSystem.deleteDirectory(dir);
		});
		watcher.errorSignal.on(e -> trace(e));
		watcher.changeSignal.on(events.push);

		nusys.FileSystem.mkdir('$dir/foo');

		TestBase.uvRun(true);
		trace(events);
		t(events.length == 1 && events[0].match(Rename("foo")));
		events.resize(0);

		var file = nusys.FileSystem.open('$dir/foo/hello.txt', "w");
		file.truncate(10);
		file.close();
		nusys.FileSystem.unlink('$dir/foo/hello.txt');

		nusys.FileSystem.rmdir('$dir/foo');

		TestBase.uvRun(true);
		t(events.length == 2 && events[0].match(Rename("foo/hello.txt")));
		t(events.length == 2 && events[1].match(Rename("foo")));
		events.resize(0);

		watcher.close();
		TestBase.uvRun(true);
	}
}
