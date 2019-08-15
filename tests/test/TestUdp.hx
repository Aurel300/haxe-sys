package test;

import haxe.io.Bytes;
import utest.Async;

using nusys.net.AddressTools;

class TestUdp extends Test {
	#if eval
	function testEcho(async:Async) {
		sub(async, done -> {
			var server = nusys.async.net.UdpSocket.create(Ipv4);
			server.bind("127.0.0.1".toIp(), 3232);
			server.messageSignal.on(msg -> {
				beq(msg.data, TestBase.helloBytes);
				server.close(err -> {
					eq(err, null);
					done();
				});
			});
		});

		sub(async, done -> {
			var client = nusys.async.net.UdpSocket.create(Ipv4);
			client.send(TestBase.helloBytes, 0, TestBase.helloBytes.length, "127.0.0.1".toIp(), 3232, (err) -> {
				eq(err, null);
				client.close(err -> {
					eq(err, null);
					done();
				});
			});
		});

		TestBase.uvRun();
	}

	function testEcho6(async:Async) {
		sub(async, done -> {
			var server = nusys.async.net.UdpSocket.create(Ipv6);
			server.bind(AddressTools.localhost(Ipv6), 3232);
			server.messageSignal.on(msg -> {
				beq(msg.data, TestBase.helloBytes);
				server.close(err -> {
					eq(err, null);
					done();
				});
			});
		});

		sub(async, done -> {
			var client = nusys.async.net.UdpSocket.create(Ipv6);
			client.send(TestBase.helloBytes, 0, TestBase.helloBytes.length, AddressTools.localhost(Ipv6), 3232, (err) -> {
				eq(err, null);
				client.close(err -> {
					eq(err, null);
					done();
				});
			});
		});

		TestBase.uvRun();
	}
	#end
}
