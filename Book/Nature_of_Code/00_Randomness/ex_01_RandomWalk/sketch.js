// Example 0.1: A Traditional Random Walk

let walker;

function setup() {
  createCanvas(640, 240);
  walker = new Walker();
  background(0);
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
    stroke(255);
    // strokeWeight(10);
    point(this.x, this.y);
  }
  
  step() {
    let xstep = random(-1, 1);
    let ystep = random(-1, 1);
    
    this.x += xstep;
    this.y += ystep;
  }
}