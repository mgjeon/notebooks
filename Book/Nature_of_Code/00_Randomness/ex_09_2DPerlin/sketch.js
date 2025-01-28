// Figure 0.9: 2D noise, each pixel represents a noise value as a grayscale color

function setup() {
  createCanvas(640, 240);

  loadPixels();
  let xoff = 0.0;

  for (let x = 0; x < width; x++) {
    let yoff = 0.0;

    for (let y = 0; y < height; y++) {
      let bright = map(noise(xoff, yoff), 0, 1, 0, 255);
      set(x, y, floor(bright));
      yoff += 0.01;
    }
    xoff += 0.01;
  }
  updatePixels();
}

function draw() {
}