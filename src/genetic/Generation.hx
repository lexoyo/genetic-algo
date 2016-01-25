package genetic;

class Generation {
  public var creatures : Array<Creature>;
  private function new ( creatures : Array<Creature> ) {
    this.creatures = creatures;
  }
  public static function createRandom( numCreatures : Int, genotypeStructure : Array<{ numGenes:Int }> ) : Generation {
    // create an array of creatures
    var creatures : Array<Creature> = [ for (i in 0...numCreatures) {
      // with radom chromosomes
      var chromosomes : Array<Chromosome> = [ for (structure in genotypeStructure) Chromosome.createRandom( structure.numGenes ) ];
      // add this to the array
      new Creature(chromosomes);
    }];
    return new Generation( creatures );
  }
  public function evolve( numWinners : Int, numRandomWinners : Int, mutationPercent:Int ) : Generation {
    creatures.sort( function (creature1, creature2) { return creature1.score - creature2.score; } );
    // choose winners
    var winners:Array<Creature> = creatures.slice(0, numWinners);
    // add random individuals
    for( i in 0...numRandomWinners) winners.push( creatures[Math.floor(Math.random() * creatures.length)]);
    // create children, orgy time
    var children:Array<Creature> = [];
    for(idx1 in 0...winners.length) {
      for(idx2 in (idx1+1)...winners.length) {
        children.push( Creature.procreate( winners[idx1], winners[idx2], mutationPercent ));
      }
    }
    return new Generation( children );
  }
  public function toString() : String {
    return "[Generation:: ${creatures.length} creatures]";
  }
}
