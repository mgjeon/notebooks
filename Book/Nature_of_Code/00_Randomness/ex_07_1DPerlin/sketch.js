// 1D Perlin noise random walker

let t = 0;

function setup() {
  createCanvas(640, 360);
}

function draw() {
  background(255);
  stroke(0);
  // let x = random(0, width);
  let n = noise(t);
  let x = map(n, 0, 1, 0, width);
  circle(x, 180, 16);
  t += 0.01
}