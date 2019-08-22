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
				beq(chunk, TestConstants.helloBytes);
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
					t(client.remoteAddress.match(Unix("resources-rw/ipc-pipe")));
					client.errorSignal.on(err -> assert());
					client.write(TestConstants.helloBytes);
					client.dataSignal.on(chunk -> {
						beq(chunk, TestConstants.helloBytes);
						client.destroy((err) -> {
							eq(err, null);
							done();
						});
					});
				});
		});

		TestBase.uvRun();
	}

	function testIpcEcho(async:Async) {
		var proc = TestBase.helperStart("ipcEcho", [], {
			stdio: [Ipc, Inherit, Inherit]
		});
		proc.messageSignal.on((message:{message:{a:Array<Int>, b:String, d:Bool}}) -> {
			t(switch (message.message) {
				case {a: [1, 2], b: "c", d: true}: true;
				case _: false;
			});
			proc.close(err -> {
				eq(err, null);
				async.done();
			});
		});
		proc.send({message: {a: [1, 2], b: "c", d: true}});

		TestBase.uvRun();
	}
	#end
}