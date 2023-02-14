import oscP5.*;
import netP5.*;

//for OSC
OscP5 oscP5;
//where to send the commands to
NetAddress[] server;


//we'll keep the cubes here
Cube[] cubes;

// Track specific toio functions to easy to digest references
HashMap<String, Cube> toioMap;

Keystone ks;
CornerPinSurface surface, surface2, surface3;
PGraphics offscreen, offscreen2, offscreen3;

PImage hr;
PImage slider;

void settings() {
  size(1000, 1000, P3D);
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
  server[0] = new NetAddress("127.0.0.1", 3334);


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
}

float convertCoordSystem(float coord, int oldSysMin, int oldSysMax, int newSysMin, int newSysMax) {
  float newSysRange = newSysMax - newSysMin + 1;
  
  float oldSysRange = oldSysMax - oldSysMin + 1;
  
  float fromLowerBound = coord - oldSysMin;
  float rangeAmount = fromLowerBound / oldSysRange;
  
  float newCoord = newSysMin + rangeAmount * newSysRange;

  return newCoord;
}



Cube hrCubeInput = null;
Cube timelineCubeInput = null;
Cube topLeftStarOutput = null;
Cube topRightStarOutput = null;
Cube bottomLeftStarOutput = null;
Cube bottomRightStarOutput = null;
Cube orbitingPlanetOutput = null;

boolean calibrated = false;
  
void initCalibrate() {
  // Initializing function to assign toio to specific interface parts
    for (int i = 0; i< cubes.length; ++i) {
      float x = cubes[i].getXPos();
      float y = cubes[i].getYPos();
      if (x < -20 && y < -20) {
        toioMap.put("hr", cubes[i]); // top left quadrant, left mat
      } else if (x > 20 && y < -20) {
        toioMap.put("planet_orbit", cubes[i]); // top right quadrant, right mat
      } else if (x < -20 && y > 20) {
        toioMap.put("timeline", cubes[i]); // bottom left quadrant, left mat
      } else if (x > -20 && x < 50 && y > -20 && y < 50) {
        toioMap.put("star_top_l", cubes[i]);
      } else if (x > 50 && y > -20 && y < 50) {
        toioMap.put("star_top_r", cubes[i]);
      } else if (x > -20 && x < 50 && y > 50) {
        toioMap.put("star_bot_l", cubes[i]);
      } else if (x > 50 && y > 50) {
        toioMap.put("star_bot_r", cubes[i]);
      }
    }
  if (toioMap.size() == 7) {
    calibrated = true;
  }
}

void projection_setup() {
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(400, 400, 20);
  surface2 = ks.createCornerPinSurface(400, 400, 20);
  surface3 = ks.createCornerPinSurface(400, 400, 20);
  offscreen = createGraphics(400, 400, P3D);
  offscreen2 = createGraphics(400, 400, P3D);
  offscreen3 = createGraphics(400, 400, P3D);
  hr = loadImage('hr_static.png');
  slider = loadImage('slider.png');
}

void draw() {

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

  //START DO NOT EDIT
  
  //the motion function sends a constant request for motion data from a toio ID
  //motionRequest(0);
  // background(255);
  // stroke(0);
  // long now = System.currentTimeMillis();

  // //draw the "mat"
  // fill(255);
  // rect(45, 45, 410, 410);

  // //draw the cubes
  // for (int i = 0; i < cubes.length; ++i) {
    
  // }
  
  int i = 0;
  for (HashMap.Entry<String, Cube> mapElement : toioMap.entrySet()) {
      String name = mapElement.getKey();
      Cube cube = mapElement.getValue();
      if (cube.isLost==false) {
        pushMatrix();
        translate(cube.x, cube.y);
        rotate(cube.deg * PI/180);
        rect(-10, -10, 20, 20);
        rect(0, -5, 20, 10);
        popMatrix();
      }
      
      fill(0, 0, 0);
    text("Cube ID: " + name + " at (" + String.valueOf(cube.getXPos()) + ", " +
       String.valueOf(cube.getYPos()) +")", 500, 100 + 60 * i);
    text("Left motor speed: " + String.valueOf(cube.speed_left), 500, 120 + 60 * i);
    text("Right motor speed: " + String.valueOf(cube.speed_right), 500, 140 + 60 * i);
    
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
     return;
    }

    // Allows cubes to move towards target
    for (i = 0; i< nCubes; ++i) {
      if (cubes[i].isLost==false) {
        fill(0, 255, 0);
        
        aimCubeSpeed(i, cubes[i].targetx, cubes[i].targety);
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
  //END DO NOT EDIT

  // trail_draw();
  // planet_draw();

  
}
