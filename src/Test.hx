class Test {
  private static inline var NUM_CREATURES:Int = 1000;
  private static inline var NUM_GENERATIONS:Int = 1000;
  private static inline var NUM_WINNERS:Int = 5;
  static function main() {
    var test:Test = new Test();
  }
  function new() {
    trace("start !");
    var creatures:Array<Creature> = new Array();
    for(i in 0...NUM_CREATURES) creatures.push(Creature.randomize());
    for(i in 0...NUM_GENERATIONS) {
      creatures = learningStep(creatures);
    }
  }
  function learningStep(creatures: Array<Creature>): Array<Creature> {
    var teacher:Teacher = new Teacher(creatures);
    teacher.start();

    while(!teacher.isOver()) {
      for(creature in creatures) {
        // trace("new creature", creature.id, creature.toString());
        creature.loop();
        teacher.loop(creature);
      }
      teacher.turn();
      // Sys.sleep(.01);
    }
    teacher.stop();
    // det the winners
    var best:Array<Creature> = new Array();
    // order creatures by score
    creatures.sort(function (creature1, creature2) {
      return teacher.getScore(creature2) - teacher.getScore(creature1);
    });
    var numWinners = NUM_WINNERS;
    for(creature in creatures) {
      cpp.Lib.println(creature.id + " scores " + Std.string(teacher.getScore(creature)) + " points (" + creature.toString() + ")");
      best.push(creature);
      if(--numWinners <= 0) {
        break;
      }
    }
    // make a new population
    var newBatch: Array<Creature> = new Array();
    while(newBatch.length < NUM_CREATURES) {
      for(idx1 in 0...best.length) {
        for (idx2 in (idx1+1)...best.length) {
          newBatch.push(Creature.evolve(best[idx1], best[idx2]));
        }
      }
    }
    trace("new batch", newBatch.length);
    return newBatch;
  }
}

