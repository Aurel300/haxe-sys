#!/usr/bin/env python3

# `python3 tcp-connect.py <port>`
#
# Listens for a connection on `localhost:<port>`, exits with 0 if there was a
# connection, 1 if there was no connection in 2 seconds.
#
# Used in `TestTCP.testConnect`.

import socket, sys

HOST = "127.0.0.1"
PORT = int(sys.argv[1])
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
s.settimeout(2.0)
try:
  conn, addr = s.accept()
  conn.close()
  s.close()
  sys.exit(0)
except socket.timeout:
  sys.exit(1)
