package neuralnet;

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
    if ( input.length != weights.length ) throw "Could not compute output for the neuron since number of inputs differs from number of weights";
    var result : Float = 0;
    for ( i in 0...input.length) {
      result += input[i] * weights[i];
    }
    return if( result >= bias ) result;
    else 0;
  }
}

