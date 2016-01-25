package pathfinder;

enum Action {
  NONE;
  UP;
  DOWN;
  LEFT;
  RIGHT;
}

class Game {
  private var objects : Array<Object>;
  private var map : Map;
  public function new ( objects : Array<Object> ) {
    this.objects = objects;
    map = new Map();
    for ( object in objects ) {
      map.set( object.x, object.y, object );
    }
  }
  /**
   * move objects, handle collisions, display the map
   */
  public function nextTurn () {
    for ( object in objects ) {
      // compute object movement
      var offset = switch ( object.action ) {
        case UP:
          {x: 0, y: 1};
        case DOWN:
          {x: 0, y: -1};
        case LEFT:
          {x: -1, y: 0};
        case RIGHT:
          {x: 1, y: 0};
        case NONE:
          {x: 0, y: 0};
      }
      // handle collision
      var destCell = null;
      var outOfMap = false;
      try {
        map.get( object.x + offset.x, object.y + offset.y);
      }
      catch ( e : Dynamic ) {
        outOfMap = true;
      }
      if ( destCell != null) {
        collide( object, destCell );
      }
      // move object if there is no collision
      else if ( !outOfMap ) {
        map.set( object.x, object.y, null );
        object.x += offset.x;
        object.y += offset.y;
        map.set( object.x, object.y, object );
      }
    }
  }
  /**
   * called upon collision
   */
  public function collide ( object1 : Object, object2 : Object ) {
    object1.collide( object2 );
    object2.collide( object1 );
  }
}
