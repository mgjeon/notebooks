// Example 0.3: A Walker That Tends to Move to the Right

let walker;

function setup() {
  createCanvas(640, 240);
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
    // strokeWeight(10);
    point(this.x, this.y);
  }
  
  step() {
    let r = random(1);
    // A 40% chance of moving to the right
    if (r < 0.4) {
      this.x++;
    } else if (r < 0.6) {
      this.x--;
    } else if (r < 0.8) {
      this.y++;
    } else {
      this.y--;
    }
  }
}