package test;

class TestAsyncFileSystem extends Test {
	function setup() {
		TestBase.uvSetup();
	}

	function teardown() {
		TestBase.uvTeardown();
	}

	function testAsync(async:utest.Async) {
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

	@:timeout(1000)
	#if hl
	// TODO
	@Ignored
	#end
	function testWatcher() {
		var events = [];

		var watcher = nusys.FileSystem.watch("resources-rw", true, true);
		watcher.changeSignal.on(events.push);

		nusys.FileSystem.mkdir("resources-rw/foo");

		TestBase.uvRun(true);
		t(events.length == 1 && events[0].match(Change("foo")));
		events.resize(0);

		var file = nusys.FileSystem.open("resources-rw/foo/hello.txt", "w");
		file.truncate(10);
		file.close();
		nusys.FileSystem.unlink("resources-rw/foo/hello.txt");

		nusys.FileSystem.rmdir("resources-rw/foo");

		TestBase.uvRun(true);
		t(events.length == 2 && events[0].match(Change("foo/hello.txt")));
		t(events.length == 2 && events[1].match(Change("foo")));
		events.resize(0);

		watcher.close();
	}
}
