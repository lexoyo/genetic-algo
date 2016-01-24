package neuralnet;

class Network {
  public var layers : Array<Layer>;
  public function new ( weights : Array<Array<Array<Float>>>, biases : Array<Array<Float>> ) {
    layers = [ for ( i in 0...weights.length ) new Layer( weights[i], biases[i] )];
  }
  public function compute ( input : Array<Float> ) : Array<Float> {
    // compute each layer's output and returns the last one
    var lastOutput = input;
    for ( layer in layers) {
      lastOutput = layer.compute ( lastOutput );
    }
    return lastOutput;
  }
}

