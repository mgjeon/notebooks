// Example 0.4: A Gaussian Distribution

function setup() {
  createCanvas(640, 240);
  background(255);
}

function draw() {
  let x = randomGaussian(320, 60);
  
  noStroke();
  fill(0, 10);
  circle(x, 120, 16);
}