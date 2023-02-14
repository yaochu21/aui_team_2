import deadpixel.keystone.*;

import oscP5.*;
import netP5.*;


//for OSC
OscP5 oscP5;
//where to send the commands to
NetAddress[] server;


//we'll keep the cubes here
Cube[] cubes;

// Track specific toio functions to easy to digest references
HashMap<String, Cube>;

Keystone ks;
CornerPinSurface surface, surface2, surface3, surface4;
PGraphics offscreen, offscreen2, offscreen3, offscreen4;

PImage hr;
PImage slider;

void settings() {
  size((int) (.75 * 3120), (int) (.75 *  2160), P3D);
}

void setup() {

  projection_setup();


  // for OSC
  // receive messages on port 3333
  oscP5 = new OscP5(this, 3333);

  //send back to the BLE interface
  //we can actually have multiple BLE bridges
  server = new NetAddress[1]; //only one for now
  //send on port 3334
  server[0] = new NetAddress("127.0.0.1", 3334)  ;

  println("Starting program!");
  //create cubes
  cubes = new Cube[nCubes];
  for (int i = 0; i< cubes.length; ++i) {
    cubes[i] = new Cube(i, true);
  }
  toioMap = new HashMap();
  //do not send TOO MANY PACKETS
  //we'll be updating the cubes every frame, so don't try to go too high
  frameRate(30);


  trail_setup();
  planet_setup();
  ks.toggleCalibration();
}

float convertCoordSystem(float coord, int oldSysMin, int oldSysMax, int newSysMin, int newSysMax) {
  float newSysRange = newSysMax - newSysMin + 1;
  
  float oldSysRange = oldSysMax - oldSysMin + 1;
  
  float fromLowerBound = coord - oldSysMin;
  float rangeAmount = fromLowerBound / oldSysRange;
  
  float newCoord = newSysMin + rangeAmount * newSysRange;

  return newCoord;
}

boolean calibrated = false;
  
void initCalibrate() {
  // Initializing function to assign toio to specific interface parts
    for (int i = 0; i< cubes.length; ++i) {
      float x = cubes[i].getXPos();
      float y = cubes[i].getYPos();
      if (x < -20 && y < -20) {
        cubes[i].setXCoord(-100);
        cubes[i].setYCoord(-100);
        toioMap.put("hr", cubes[i]); // top left quadrant, left mat
      } else if (x > 20 && y < -20) {
        cubes[i].setXCoord(100);
        cubes[i].setYCoord(100);
        toioMap.put("planet_orbit", cubes[i]); // top right quadrant, right mat
      } else if (x < -20 && y > 20) {
        cubes[i].setXCoord(0);
        cubes[i].setYCoord(50);
        toioMap.put("timeline", cubes[i]); // bottom left quadrant, left mat
      } else if (x > -20 && x < 50 && y > -20 && y < 50) {
        cubes[i].setXCoord(-50);
        cubes[i].setYCoord(-50);
        toioMap.put("star_top_l", cubes[i]);
      } else if (x > 50 && y > -20 && y < 50) {
        cubes[i].setXCoord(50);
        cubes[i].setYCoord(-50);
        toioMap.put("star_top_r", cubes[i]);
      } else if (x > -20 && x < 50 && y > 50) {
        cubes[i].setXCoord(-50);
        cubes[i].setYCoord(50);
        toioMap.put("star_bot_l", cubes[i]);
      } else if (x > 50 && y > 50) {
        cubes[i].setXCoord(50);
        cubes[i].setYCoord(50);
        toioMap.put("star_bot_r", cubes[i]);
      }
    }
  if (toioMap.size() == 7) {
    calibrated = true;
  }
}

<<<<<<< HEAD
void projection_setup() {
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(800, 800, 20);
  surface2 = ks.createCornerPinSurface(1000, 1080, 20);
  surface3 = ks.createCornerPinSurface(800, 400, 20);
  surface4 = ks.createCornerPinSurface(800, 800, 20);
  offscreen = createGraphics(400, 400, P3D);
  offscreen2 = createGraphics(1000, 1080, P3D);
  offscreen3 = createGraphics(400, 4800, P3D);
  offscreen4 = createGraphics(800, 800, P3D);
  hr = loadImage("hr_static.png");
  hr.resize(1000,1080);
  slider = loadImage("slider.png");
  slider.resize(400,100);
}

void draw() {
  print(toioMap.size());
  offscreen2.beginDraw();
  offscreen2.background(0);
  offscreen2.image(hr, 0, 0);
  offscreen2.endDraw();

  offscreen3.beginDraw();
  offscreen3.background(0);
  offscreen3.image(slider, 0, 0);
  offscreen3.endDraw();

  background(0);
  offscreen4.beginDraw();
  
  

  
  
=======
void draw() {
>>>>>>> 587a025adb8f14a5313c4498f78553eac03d2164

  //START DO NOT EDIT
  
  //the motion function sends a constant request for motion data from a toio ID
  //motionRequest(0);
   offscreen4.background(255);
   offscreen4.stroke(0);
   long now = System.currentTimeMillis();

  // //draw the "mat"
   offscreen4.fill(255);
   offscreen4.rect(45, 45, 410, 410);

  // //draw the cubes
  // for (int i = 0; i < cubes.length; ++i) {
    
  // }
  
  int i = 0;
  for (HashMap.Entry<String, Cube> mapElement : toioMap.entrySet()) {
      String name = mapElement.getKey();
      Cube cube = mapElement.getValue();
      if (cube.isLost==false) {
        offscreen4.pushMatrix();
        offscreen4.translate(cube.x, cube.y);
        offscreen4.rotate(cube.deg * PI/180);
        offscreen4.rect(-10, -10, 20, 20);
        offscreen4.rect(0, -5, 20, 10);
        offscreen4.popMatrix();
      }
      
    offscreen4.fill(0, 0, 0);
    offscreen4.text("Cube ID: " + name + " at (" + String.valueOf(cube.getXPos()) + ", " +
       String.valueOf(cube.getYPos()) +")", 500, 100 + 60 * i);
    offscreen4.text("Left motor speed: " + String.valueOf(cube.speed_left), 500, 120 + 60 * i);
    offscreen4.text("Right motor speed: " + String.valueOf(cube.speed_right), 500, 140 + 60 * i);
    
    if (name.equals("hr") || name.equals("timeline")) {
      OscMessage msg = new OscMessage("/toio_input");
      msg.add(name);
      msg.add(cube.getXPos());
      msg.add(cube.getYPos());
      
      oscP5.send(msg, server[0]);
    }
    i += 1;
  }
  
    if (!calibrated) {
     initCalibrate(); 
     if (calibrated) {
       midi(0, 64, 255, 10);
     }
    } else {
      for (HashMap.Entry<String, Cube> mapElement : toioMap.entrySet()) {
      String name = mapElement.getKey();
      Cube cube = mapElement.getValue();
      
      if (!cube.isLost) {
        offscreen4.fill(0, 255, 0);
        println("Moving ", name, " to ", cube.targetx, cube.targety);
        aimCubeSpeed(cube.id, cube.targetx, cube.targety);
      }
    }
    
    
      
  }

  //START DO NOT EDIT
  //did we lost some cubes?
  for (i=0; i<nCubes; ++i) {
    // 500ms since last update
    cubes[i].p_isLost = cubes[i].isLost;
    if (cubes[i].lastUpdate < now - 1500 && cubes[i].isLost==false) {
      cubes[i].isLost= true;
    }
  }
  
  offscreen4.endDraw();
  
  surface3.render(offscreen3);
  surface2.render(offscreen2);
  surface4.render(offscreen4);
  //END DO NOT EDIT

<<<<<<< HEAD
  // trail_draw();
  // planet_draw();

}

boolean calibration = true;

void keyPressed() {
  switch (key) {
  case 'c':
    ks.toggleCalibration();
    calibration = !calibration;
    break;
  }
=======
  // no arguments
  project_hr_and_slider();

  // arguments:
  // float x, float y, float rad, float r, float g, float b
  // x, y at center of the second toio map
  project_planet();

  // arguments:
  // 1. float x pos of orbiting toio
  // 2. float y pos of orbiting toio transformed
  float orbit_x = toioMap.get("planet_orbit").getXPos();
  float orbit_y = toioMap.get("planet_orbit").getYPos();
  orbit_x = convertCoordSystem(orbit_x,-100,100,0,1000);
  orbit_y = convertCoordSystem(orbit_y,-100,100,0,1000);
  project_trail(orbit_x,orbit_y);
  
>>>>>>> 587a025adb8f14a5313c4498f78553eac03d2164
}
