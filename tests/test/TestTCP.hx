package test;

import utest.Async;

class TestTCP extends Test {
	#if eval
	override function setup():Void {
		TestBase.uvSetup();
	}

	override function teardown():Void {
		TestBase.uvTeardown();
		TestBase.helperTeardown();
	}

	@:timeout(3000)
	function testConnect(async:Async):Void {
		var parts = 0;
		function partDone():Void {
			if (++parts == 2)
				async.done();
		}

		var server = new nusys.async.net.Socket();
		server.bindTCP(3232);
		server.listen(1, (err) -> {
			eq(err, null);
			var sclient = server.accept();
			sclient.end((err) -> {
				eq(err, null);
				server.close((err) -> {
					eq(err, null);
					partDone();
				});
			});
		});

		var client = new nusys.async.net.Socket();
		client.connectTCP(3232, (err) -> {
			eq(err, null);
			client.end((err) -> {
				eq(err, null);
				partDone();
			});
		});

		TestBase.uvRun();
	}
	#end
}
