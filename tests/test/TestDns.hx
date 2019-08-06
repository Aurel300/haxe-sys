package test;

import haxe.io.Bytes;
import utest.Async;

class TestDns extends Test {
	#if eval
	function testLocalhost(async:Async) {
		sub(async, done -> nusys.net.Dns.lookup("localhost", {family: IPv4}, (err, res) -> {
			eq(err, null);
			t(res[0].match(IPv4(0x7F000001)));
			done();
		}));

		TestBase.uvRun();
	}

	function testIPv4(async:Async) {
		sub(async, done -> nusys.net.Dns.lookup("127.0.0.1", {family: IPv4}, (err, res) -> {
			eq(err, null);
			t(res[0].match(IPv4(0x7F000001)));
			done();
		}));
		sub(async, done -> nusys.net.Dns.lookup("123.32.10.1", {family: IPv4}, (err, res) -> {
			eq(err, null);
			t(res[0].match(IPv4(0x7B200A01)));
			done();
		}));
		sub(async, done -> nusys.net.Dns.lookup("255.255.255.255", {family: IPv4}, (err, res) -> {
			eq(err, null);
			t(res[0].match(IPv4(0xFFFFFFFF)));
			done();
		}));

		TestBase.uvRun();
	}

	function testIPv6(async:Async) {
		sub(async, done -> nusys.net.Dns.lookup("::1", {family: IPv6}, (err, res) -> {
			eq(err, null);
			t(res[0].match(IPv6(beq(_, Bytes.ofHex("00000000000000000000000000000001")) => _)));
			done();
		}));
		sub(async, done -> nusys.net.Dns.lookup("2001:db8:1234:5678:11:2233:4455:6677", {family: IPv6}, (err, res) -> {
			eq(err, null);
			t(res[0].match(IPv6(beq(_, Bytes.ofHex("20010DB8123456780011223344556677")) => _)));
			done();
		}));
		sub(async, done -> nusys.net.Dns.lookup("4861:7865:2069:7320:6177:6573:6F6D:6521", {family: IPv6}, (err, res) -> {
			eq(err, null);
			t(res[0].match(IPv6(beq(_, Bytes.ofHex("4861786520697320617765736F6D6521")) => _)));
			done();
		}));

		TestBase.uvRun();
	}
	#end
}
