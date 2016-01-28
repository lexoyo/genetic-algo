package neuralnet;

/**
 * Handle the smallest unit of data. Sums its inputs and apply the bias.
 */
class Neuron {
  private var weights : Array<Float>;
  private var bias : Float;
  public function new ( weights : Array<Float>, bias : Float ) {
    this.weights = weights;
    this.bias = bias;
  }
  /**
   * compute the output value for the given input values
   */
  public function compute ( input : Array<Float> ) : Float {
    if ( input.length != weights.length ) throw 'Could not compute output for the neuron since number of inputs differs from number of weights (${input.length} ${weights.length})';
    var prod : Float = 0;
    var sum : Float = 0;
    for ( i in 0...input.length) {
      prod += input[i] * weights[i];
      sum += input[i] + weights[i];
    }
    var result = prod / sum;
    return if( result >= bias ) result;
    else 0;
  }
}

