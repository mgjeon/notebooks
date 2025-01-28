// Example 0.6: A Perlin Noise Walker

let walker;

function setup() {
  createCanvas(400, 400);
  walker = new Walker();
  background(255);
}

function draw() {
  walker.step();
  walker.show();
}

class Walker {
  constructor() {
    this.tx = 0;
    this.ty = 10000;
  }
  
  show() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    circle(this.x, this.y, 48);
  }
  
  step() {
    this.x = map(noise(this.tx), 0, 1, 0, width);
    this.y = map(noise(this.ty), 0, 1, 0, height);
    
    this.tx += 0.01;
    this.ty += 0.01;
  }
}