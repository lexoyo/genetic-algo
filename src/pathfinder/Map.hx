package pathfinder;

class Map {
  public static inline var SIZE_X = 20;
  public static inline var SIZE_Y = 20;
  private var objects : Array<Array<Object>>;
  public function new() {
    objects = [ for (x in 0...SIZE_X) [ for (y in 0...SIZE_Y ) null ]];
  }

  public function set( x: Int, y: Int, object : Null<Object> ) {
    if ( x < 0 || x >= SIZE_X || y < 0 || y >= SIZE_Y) {
      throw "Out of range";
    }
    objects[x][y] = object;
  }
  public function get( x: Int, y: Int ) : Null<Object> {
    if ( x < 0 || x >= SIZE_X || y < 0 || y >= SIZE_Y) {
      throw "Out of range";
    }
    return objects[x][y];
  }
}

