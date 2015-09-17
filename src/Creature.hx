class Creature {
  public static inline var NUM_GENES: Int = 10;
  private static var nextId = 0;
  private var genome: Array<Gene>;
  public var x: Float;
  public var y: Float;
  public var id: Int;
  public var currentGeneIdx: Int = 0;

  public static function randomize(): Creature {
    var creature = new Creature();
    for(idx in 0...NUM_GENES) {
      creature.genome[idx] = Gene.randomize();
    }
    return creature;
  }
  public static function evolve(creature1: Creature, creature2: Creature): Creature {
    var creature = new Creature();
    for(idx in 0...NUM_GENES) {
      creature.genome[idx] = Gene.evolve(creature1.genome[idx], creature2.genome[idx]);
    }
    return creature;
  }
  public function new() {
    id = nextId++;
    x = 100;
    y = 100;
    genome = new Array();
  }
  public function loop() {
    if(currentGeneIdx < NUM_GENES) {
      currentGeneIdx = Gene.exec(this, genome[currentGeneIdx]);
    }
  }
  public function toString() {
    var genes: Array<String> = genome.map(function (gene) {return gene.toString();});
    return "Creature:: " + id + " (" + Math.round(x) + ", " + Math.round(y) + ") [" + genes.join(", ") + "]";
  }
}

