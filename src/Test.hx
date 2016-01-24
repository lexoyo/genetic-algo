class Test {
  private static inline var NUM_CREATURES:Int = 500;
  private static inline var NUM_GENERATIONS:Int = 10;
  private static inline var NUM_WINNERS:Int = 10;
  private static inline var NUM_ROUNDS:Int = 5;

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
    var network = new neuralnet.Network ( new Array(), new Array() );
    var teacher:Teacher = new Teacher(creatures);
    for(match in 0...NUM_ROUNDS) {
      teacher.start();
      while(!teacher.isOver()) {
        for(creature in creatures) {
          // trace("new creature", creature.id, creature.toString());
          creature.loop();
          // if(creature.id == 50000) trace("-> ", creature.toString(), teacher.getScore(creature));
          teacher.loop(creature);

          //if(Teacher.MAX_TURNS == teacher.turns + 1)
          //  cpp.Lib.print(teacher.getRoute(creature));
        }
        teacher.turn();
        // Sys.sleep(.01);
      }
      teacher.stop();
    }
    // det the winners
    var best:Array<Creature> = new Array();
    // order creatures by score
    creatures.sort(function (creature1, creature2) {
      return teacher.getScore(creature2) - teacher.getScore(creature1);
    });
    var numWinners = NUM_WINNERS;
    var sum = 0;
    for(creature in creatures) {
      if(--numWinners > 0) {
        best.push(creature);
      }
      sum += teacher.getScore(creature);
    }
    // make a new population
    var newBatch: Array<Creature> = new Array();
    while(newBatch.length < NUM_CREATURES) {
      for(idx1 in 0...best.length) {
        for (idx2 in 0...best.length) {
          // TODO: do not include evolve(idx, idx) ?
          newBatch.push(Creature.evolve(best[idx1], best[idx2]));
        }
      }
    }
    var creature = best[0];
    cpp.Lib.print("\033[2J\n\n=====================================================================================================================================================================\nBest Score: " + Std.string(teacher.getScore(creature)) + "\n" + creature.toString() + "\n" + teacher.getRoute(creature));
    return newBatch;
  }
}

