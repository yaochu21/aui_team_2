import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surface, surface2, surface3;
PGraphics offscreen, offscreen2, offscreen3;

// offscreen/surface1: orbit demo
// offscreen/surface2: hr diagram
// offscreen/surface3: slider

PImage hr;
PImage slider;


void project_hr_and_slider() {
  offscreen2.beginDraw();
  offscreen2.background(0);
  offscreen2.image(hr, 0, 0);
  offscreen2.endDraw();

  offscreen3.beginDraw();
  offscreen3.background(0);
  offscreen3.image(slider, 0, 0);
  offscreen3.endDraw();

  background(0);
  surface2.render(offscreen2);
  surface3.render(offscreen3);
}

void projection_setup() {
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(400, 400, 20);
  surface2 = ks.createCornerPinSurface(1000, 1080, 20);
  surface3 = ks.createCornerPinSurface(400, 400, 20);
  offscreen = createGraphics(400, 400, P3D);
  offscreen2 = createGraphics(1000, 1080, P3D);
  offscreen3 = createGraphics(400, 400, P3D);
  hr = loadImage("hr_static.png");
  hr.resize(1000,1080);
  slider = loadImage("slider.png");
  slider.resize(400,100);
}

 void keyPressed() {
   switch(key) {
   case 'c':
     // enter/leave calibration mode, where surfaces can be warped 
     // and moved
     ks.toggleCalibration();
     break;

   case 'l':
     // loads the saved layout
     ks.load();
     break;

   case 's':
     // saves the layout
     ks.save();
     break;
   }
 }
