import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surface, surface2;

PGraphics offscreen, offscreen2;
PImage ken, anup;

void setup() {
  // Keystone will only work with P3D or OPENGL renderers, 
  // since it relies on texture mapping to deform
  size(800, 600, P3D);

  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(400, 400, 20);
  surface2 = ks.createCornerPinSurface(400, 400, 20);
  
  // We need an offscreen buffer to draw the surface we
  // want projected, note that we're matching the resolution
  // of the CornerPinSurface.
  // (The offscreen buffer can be P2D or P3D)
  ken = loadImage("ken.png");
  ken.resize(400, 400);
  anup = loadImage("nup.png");
  anup.resize(400, 400);
  offscreen = createGraphics(400, 400, P3D);
  offscreen2 = createGraphics(400, 400, P3D);
}

void draw() {
  // Convert the mouse coordinate into surface coordinates
  // this will allow you to use mouse events inside the 
  // surface from your screen. 
  PVector surfaceMouse = surface.getTransformedMouse();

  // Draw the scene, offscreen
  offscreen.beginDraw();
  offscreen.background(0);
  //offscreen.fill(0, 255, 0);
  offscreen.image(anup, 0, 0);
  //offscreen.ellipse(surfaceMouse.x, surfaceMouse.y, 75, 75);
  offscreen.endDraw();
  
  // Draw the scene, offscreen
  offscreen2.beginDraw();
  offscreen2.background(0);
  offscreen2.image(ken, 0, 0);
  //offscreen2.ellipse(surfaceMouse.x, surfaceMouse.y, 75, 75);
  offscreen2.endDraw();

  // most likely, you'll want a black background to minimize
  // bleeding around your projection area
  background(0);
 
  // render the scene, transformed using the corner pin surface
  surface.render(offscreen);
  surface2.render(offscreen2);
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
