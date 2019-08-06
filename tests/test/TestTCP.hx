package test;

import haxe.io.Bytes;
import utest.Async;

class TestTcp extends Test {
	#if eval
	function testEcho(async:Async) {
		sub(async, done -> {
			var server:nusys.async.net.Server = null;
			server = sys.Net.createServer({
				listen: Tcp({
					host: "127.0.0.1",
					port: 3232
				})
			}, client -> client.dataSignal.on(chunk -> {
				beq(chunk, TestBase.helloBytes);
				client.write(chunk);
				client.destroy();
				server.close((err) -> {
					eq(err, null);
					done();
				});
			}));
		});

		TestBase.uvRun(true);

		sub(async, done -> {
			var client:nusys.async.net.Socket = null;
			client = sys.Net.createConnection({
				connect: Tcp({
					host: "127.0.0.1",
					port: 3232
				})
			}, (err) -> {
				eq(err, null);
				client.write(TestBase.helloBytes);
				client.dataSignal.on(chunk -> {
					beq(chunk, TestBase.helloBytes);
					client.destroy((err) -> {
						eq(err, null);
						done();
					});
				});
			});
		});

		TestBase.uvRun();
	}
	#end
}
