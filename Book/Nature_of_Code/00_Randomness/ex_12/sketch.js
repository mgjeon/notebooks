// https://editor.p5js.org/natureofcode/sketches/cMvdyBc4h

let yoff = 0;
let seed = 5;

function setup() {
  createCanvas(360, 240);
}

function draw() {
  background(255);
  fill(0);

  stroke(0);
  translate(width / 2, height);
  yoff += 0.005;
  randomSeed(seed);
  branch(60, 0);
}

function mousePressed() {
  yoff = random(1000);
  seed = millis();
}

function branch(h, xoff) {
  let sw = map(h, 2, 100, 1, 5);
  strokeWeight(sw);
  line(0, 0, 0, -h);
  translate(0, -h);

  h *= 0.7;

  xoff += 0.1;

  if (h > 4) {
    let n = floor(random(1, 5));
    for (let i = 0; i < n; i++) {
      let theta = map(noise(xoff+i, yoff), 0, 1, -PI/2, PI/2);
      if (n % 2 == 0) theta *= -1;

      push();
      rotate(theta);
      branch(h, xoff);
      pop();
    }
  }
}