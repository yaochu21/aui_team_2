void setup() {
    size(1000,1080);
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
    
    int diagram_start_y = 100;
    int diagram_start_x = 100;
    int diagram_len = 800;
    
    background(0,0,0);
    makeGradient(100,diagram_start_y,200,diagram_len,blue,white);
    makeGradient(300,diagram_start_y,150,diagram_len,white,white_y);
    makeGradient(450,diagram_start_y,200,diagram_len,white_y,yellow);
    makeGradient(650,diagram_start_y,250,diagram_len,yellow,red);
    
    //makeGradient(0,0,150,650,blue,white);
    //makeGradient(150,0,80,650,white,white_y);
    //makeGradient(230,0,200,650,white_y,yellow);
    //makeGradient(430,0,170,650,yellow,red);
    tint(255,255,255,50);
    image(main_seq,diagram_start_x,diagram_start_y,diagram_len,diagram_len);
    image(subgiants,diagram_start_x,diagram_start_y,diagram_len,diagram_len);
    image(supergiants,diagram_start_x,diagram_start_y,diagram_len,diagram_len);
    image(white_dwarfs,diagram_start_x,diagram_start_y,diagram_len,diagram_len);
    
    textSize(16);
    String[] llabels = {"-8","-6","-4","-2","0","2","4","6","8","10","12","14"};
    String[] bottomlabels = {"B0","A0","F0","G0","K0","M0"};
    String[] rlabels = {"10e5","10e4","10e3","10e2","10","1","10e-2","10e-3","10e-4","10e-5"};
    String[] toplabels = {"30000","10000","7000","6000","4500","4000"};
    
    makeHorizontalLabels(100,900,diagram_start_y-5,toplabels);
    makeHorizontalLabels(100,900,diagram_start_y+diagram_len+20,bottomlabels);
    makeVerticalLabels(diagram_start_y,diagram_start_y+diagram_len,diagram_start_x-25,llabels);
    makeVerticalLabels(diagram_start_y,diagram_start_y+diagram_len,diagram_start_x+diagram_len+15,rlabels);
    
    textSize(20);
    text("Effective Temp (K)",diagram_start_x + diagram_len / 2 - 40,diagram_start_y - 40);
    text("Spectral Class",diagram_start_x + diagram_len / 2 - 40,diagram_start_y + diagram_len + 50);
    translate(diagram_start_x - 40,diagram_start_y + diagram_len/2 + 50);
    rotate(-HALF_PI);
    text("Absolute Magnitude M_y",0,0);
    rotate(HALF_PI);
    translate(-(diagram_start_x - 40),-(diagram_start_y + diagram_len/2 + 50));
    translate(diagram_start_x + diagram_len + 65,diagram_start_y + diagram_len/2 - 150);
    rotate(HALF_PI);
    text("Lumniosity Compared to the Sun",0,0);
    
    save("hr_static.png");
}

void makeGradient(int x, int y, float w, float h, color c1, color c2) {
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
}

void makeVerticalLabels(float start, float end, float x, String[] labels) {
  
  float gap = (end - start) / (labels.length + 1);
  for (int i = 1; i < labels.length + 1; i++) {
     float ypos = start + i * gap;
     text(labels[i-1],x,ypos);
  }
  
}

void makeHorizontalLabels(float start, float end, float y, String[] labels) {
  
  float gap = (end - start) / (labels.length + 1);
  for (int i = 1; i < labels.length + 1; i++) {
     float xpos = start + i * gap;
     text(labels[i-1],xpos,y);
  }
  
}
