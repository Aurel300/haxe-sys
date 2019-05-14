package haxe.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.Event;

interface IStream {
  final eventClose:Event<NoData>;
  final eventError:Event<Error>;

  function destroy(?error:Error):Void;
}
