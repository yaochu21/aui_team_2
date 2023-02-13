void hr_setup() {
    size(600,650);
    noStroke();
    PImage main_seq = loadImage("main_sequence.png");
    PImage subgiants = loadImage("subgiants.png");
    PImage supergiants = loadImage("supergiants.png");
    PImage white_dwarfs = loadImage("white_dwarfs.png");

    color blue = color(150,220,255);
    color white = color(255,255,255);
    color white_y = color(254,255,238);
    color yellow = color(255,253,105);
    color orange = color(251,167,0);
    color red = color(255,0,0);
    
    makeGradient(0,0,150,650,blue,white);
    makeGradient(150,0,80,650,white,white_y);
    makeGradient(230,0,200,650,white_y,yellow);
    makeGradient(430,0,170,650,yellow,red);
    tint(255,255,255,50);
    image(main_seq,0,0,width,height);
    image(subgiants,0,0,width,height);
    image(supergiants,0,0,width,height);
    image(white_dwarfs,0,0,width,height);

    // makeGradient(0,0,150,650,blue,white);
    // makeGradient(150,0,50,650,white,white_y);
    // makeGradient(200,0,200,650,white_y,yellow);
    // makeGradient(400,0,200,650,yellow,red);
}

void makeGradient(int x, int y, float w, float h, color c1, color c2) {
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
}







// size(600,650);
//   noStroke();
//   colorMode(HSB, 400);
//   for (int i = 0; i < 400; i++) {
//     for (int j = 200; j < 400; j++) {
//       stroke(i, j, 400);
//       point(i, j);
//     }
// }
