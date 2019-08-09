package test;

import haxe.io.Bytes;
import utest.Async;

using nusys.net.AddressTools;

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
			server.listeningSignal.on(() -> {
				t(server.localAddress.match(Network(AddressTools.equals(_, "127.0.0.1".toIP()) => true, 3232)));
				done();
			});
			server.errorSignal.on(err -> assert());
		}, 2);

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
					t(client.localAddress.match(Network(AddressTools.equals(_, "127.0.0.1".toIP()) => true, _)));
					t(client.remoteAddress.match(Network(AddressTools.equals(_, "127.0.0.1".toIP()) => true, 3232)));
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

	function testSignals(async:Async) {
		sub(async, done -> {
			var client = nusys.async.net.Socket.create();
			client.errorSignal.on(err -> assert());
			client.lookupSignal.on(address -> {
				t(address.equals("127.0.0.1".toIP(), true));
				done();
			});
			client.connectTcp({
				port: 10123,
				host: "localhost",
				family: IPv4
			}, (err:haxe.Error) -> {
					switch (err.type) {
						case UVError(sys.uv.UVErrorType.ECONNREFUSED):
							client.destroy();
							done();
						case _:
							assert();
					}
				});
		}, 2);

		TestBase.uvRun();
	}
	#end
}
