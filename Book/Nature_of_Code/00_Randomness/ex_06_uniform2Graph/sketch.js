// White noise


function setup() {
  createCanvas(360, 240);
}

function draw() {
  background(255);
  noFill();
  stroke(0);
  strokeWeight(2);
  beginShape();
  for (let i = 0; i < width; i++) {
    let y = random(height);
    vertex(i, y);
  }
  endShape();
}