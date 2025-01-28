function setup() {
  createCanvas(640, 240);

  // Uniform noise
  // loadPixels();
  // for (let x = 0; x < width; x++) {

  //   for (let y = 0; y < height; y++) {
  //     let br_r = random(255);
  //     let br_g = random(255);
  //     let br_b = random(255);
  //     set(x, y, [floor(br_r), floor(br_g), floor(br_b), 255]);
  //   }
  // }
  // updatePixels();

  let r_xoff = 0.0;
  let g_xoff = 1000.0;
  let b_xoff = 2000.0;
  loadPixels();
  for (let x = 0; x < width; x++) {
    let r_yoff = 0.0;
    let g_yoff = 1000.0;
    let b_yoff = 2000.0;
    for (let y = 0; y < height; y++) {
      let br_r = map(noise(r_xoff, r_yoff), 0, 1, 0, 255);
      let br_g = map(noise(g_xoff, g_yoff), 0, 1, 0, 255);
      let br_b = map(noise(b_xoff, b_yoff), 0, 1, 0, 255);
      set(x, y, [floor(br_r), floor(br_g), floor(br_b), 255]);
      r_yoff += 0.01;
      g_yoff += 0.01;
      b_yoff += 0.01;
    }
    r_xoff += 0.01;
    g_xoff += 0.01;
    b_xoff += 0.01;
  }
  updatePixels();
}

function draw() {
}