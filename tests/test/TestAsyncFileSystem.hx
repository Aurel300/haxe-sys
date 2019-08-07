package test;

import utest.Async;

class TestAsyncFileSystem extends Test {
	function testAsync(async:Async) {
		sub(async, done -> nusys.async.FileSystem.exists("resources-ro/hello.txt", (error, exists) -> {
			t(exists);
			done();
		}));
		sub(async, done -> nusys.async.FileSystem.exists("resources-ro/non-existent-file", (error, exists) -> {
			f(exists);
			done();
		}));
		sub(async, done -> nusys.async.FileSystem.readdir("resources-ro", (error, names) -> {
			aeq(names, ["binary.bin", "hello.txt"]);
			done();
		}));

		eq(asyncDone, 0);
		TestBase.uvRun();
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
		watcher.errorSignal.on(e -> assert('unexpected error: ${e.message}'));
		watcher.changeSignal.on(events.push);

		nusys.FileSystem.mkdir('$dir/foo');

		TestBase.uvRun(true);
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
