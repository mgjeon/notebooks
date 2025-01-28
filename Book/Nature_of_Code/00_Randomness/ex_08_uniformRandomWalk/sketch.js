// A Uniform Noise Walker

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
    this.x = width / 2;
    this.y = height / 2;
  }
  
  show() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    circle(this.x, this.y, 48);
  }
  
  step() {
    let xstep = random(-5, 5);
    let ystep = random(-5, 5);
    
    this.x += xstep;
    this.y += ystep;
  }
}