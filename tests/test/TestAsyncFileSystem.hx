package test;

class TestAsyncFileSystem extends Test {
	function setup() {
		TestBase.uvSetup();
	}

	function teardown() {
		TestBase.uvTeardown();
	}

	@:timeout(2000)
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
		nusys.async.FileSystem.readdir("resources-ro", callOnce((error, names) -> aeq(names, ["hello.txt"])));

		eq(calls, 0);
		TestBase.uvRun();
		eq(calls, callsExpected);
	}
}
