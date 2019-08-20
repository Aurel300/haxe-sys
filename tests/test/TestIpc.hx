package test;

import haxe.io.Bytes;
import utest.Async;

class TestIpc extends Test {
	#if eval
	function testEcho(async:Async) {
		sub(async, done -> {
			var server:nusys.async.net.Server = null;
			server = sys.Net.createServer({
				listen: Ipc({
					path: "resources-rw/ipc-pipe"
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
			server.errorSignal.on(err -> assert());
		});

		sub(async, done -> {
			var client:nusys.async.net.Socket = null;
			client = sys.Net.createConnection({
				connect: Ipc({
					path: "resources-rw/ipc-pipe"
				})
			}, (err) -> {
					eq(err, null);
					//t(client.localAddress.match(Network(AddressTools.equals(_, "127.0.0.1".toIp()) => true, _)));
					//t(client.remoteAddress.match(Network(AddressTools.equals(_, "127.0.0.1".toIp()) => true, 3232)));
					client.errorSignal.on(err -> assert());
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
