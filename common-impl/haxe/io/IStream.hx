package haxe.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.Signal;

interface IStream {
  final closeSignal:Signal<NoData>;
  final errorSignal:Signal<Error>;

  function destroy(?error:Error):Void;
}
