package genetic;

import genetic.Chromosome;

class Creature {
  public var chromosomes: Array<Chromosome>;
  public var score:Int;

  public static function procreate(creature1: Creature, creature2: Creature, mutationPercent:Int ): Creature {
    var chromosomes:Array<Chromosome> = [];
    // for each chromosome
    for (chromosomeIdx in 0...creature1.chromosomes.length) {
      var genes:Array<Gene> = [];
      // for each gene
      for(geneIdx in 0...creature1.chromosomes[chromosomeIdx].genes.length) {
        // chose one of the parent's gene
        if(Math.random() < .5) {
          genes[geneIdx] = creature1.chromosomes[chromosomeIdx].genes[geneIdx];
        }
        else {
          genes[geneIdx] = creature2.chromosomes[chromosomeIdx].genes[geneIdx];
        }
        // mutation
        var randPercent = Math.round(Math.random() * 100);
        if(randPercent < mutationPercent) {
          genes[geneIdx] = Math.random();
        }
      }
      chromosomes[chromosomeIdx] = new Chromosome( genes );
    }
    var child = new Creature( chromosomes );
    return child;
  }
  public function new( chromosomes:Array<Chromosome> ) {
    this.chromosomes = chromosomes;
    score = 0;
  }
  public function toString() {
    // TODO: give it a name
    return "[Creature:: ${chromosomes.length} chromosomes, score: $score]";
  }
}

