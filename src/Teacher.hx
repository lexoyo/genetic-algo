typedef CreatureData = {
  score: Int
}
class Teacher {
  private static inline var MAX_TURNS:Int = 1000;
  private var turns:Int = 0;
  private var creaturesData:Array<CreatureData> = null;

  public function new(creatures: Array<Creature>) {
    creaturesData = new Array();
    for(creature in creatures) {
      creaturesData[creature.id] = {
        score: 0
      }
    }
  }
  public function start() {
    turns = 0;
  }
  public function stop() {}
  public function turn() {
    turns ++;
  }
  public function loop(creature:Creature) {
    if(creature.x <= 0 && creature.y <= 0 && creaturesData[creature.id].score == 0) {
      creaturesData[creature.id].score = MAX_TURNS - turns;
    }
  }
  public function getScore(creature:Creature):Int {
    return creaturesData[creature.id].score;
  }
  public function isOver():Bool {
    return turns >= MAX_TURNS;
  }
}

