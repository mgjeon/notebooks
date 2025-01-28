// Example 0.5: An Accept-Reject Distribution

let randomCounts = [];
let total = 20;

function setup() {
  createCanvas(640, 240);
  for (let i = 0; i < total; i++) {
    randomCounts[i] = 0;
  }
}

function draw() {
  background(255);
  
  let index = int(acceptreject() * randomCounts.length);
  randomCounts[index]++;
  
  stroke(0);
  fill(127);
  let w = width / randomCounts.length;
  
  for (let x = 0; x < randomCounts.length; x++) {
    rect(x * w, height - randomCounts[x], w - 1, randomCounts[x]);
  }
}


function acceptreject() {
  while (true) {
    
    let r1 = random(1);
    let probability = r1;
    let r2 = random(2);
    if (r2 < probability) {
      return r1;
    }
  }
}