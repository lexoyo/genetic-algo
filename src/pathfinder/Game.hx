package pathfinder;

enum Action {
  NONE;
  UP;
  DOWN;
  LEFT;
  RIGHT;
}

class Game {
  public var isOver = false;
  private var objects : Array<Object>;
  public var map : Map;
  private var numIdleTurns : Int = 0;
  private static inline var NUM_IDLE_TO_END : Int = 10;
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
    var atLeastOneMove = false;
    for ( object in objects ) {
      if( object.action != NONE ) {
        atLeastOneMove = true;
      }
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
    if (atLeastOneMove) {
      numIdleTurns = 0;
    }
    else {
      numIdleTurns++;
      if (numIdleTurns >= NUM_IDLE_TO_END) {
        isOver = true;
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
