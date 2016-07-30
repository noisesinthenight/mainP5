//main - cam img load, video?
//Copy -glitch -slitscan
//polygon

//STORE FORCES IN ARRAY!!! so can iterate, and dynamically change forces and their boundaries

//USE 2D array for storing cam +images
//access brightness use as mod source for acceleration????


import processing.video.*;
Capture cam;
color[] c = {
    color(160, 194, 241), 
  color(100, 174, 241), 
  color(200, 190, 201), 
  color(100, 150, 100),
};
ColorAvg coloravg;

Mover[] mover = new Mover[60];
//ArrayList so can be dynamic size  !!1
int reset = 0, stepSize = 2;
int lastTime = 0, timeThresh = 0;

color bgCol = color(255);
int bgOp = 0, fgOp = 250;
float sides = 3;


void setup() {
  cam = new Capture(this);
  cam.start();
//  c = new color[12];

  size(cam.width, cam.height);
  background(bgCol);
  smooth();
  gui();
  //  osc();  

  for (int i = 0; i < mover.length; i++) {    
    mover[i] = new Mover(width/2, height/2, 6); //args: x, y, mass
    mover[i].col = c[i%c.length];  //cycle through fgCol
  };
  reset = 1;
}

void bg(int val) {
  noStroke();
  fill(bgCol, val);
  rectMode(CORNERS);
  rect(0, 0, width, height);  
}



void draw() {  
  bg(bgOp);
//  grab();

  //RESET
  if (random(1.0) < 0.001) { reset = 1; };
  if (reset == 1 && (millis() - lastTime) > timeThresh) {
    lastTime = millis();
    reset = 0;
    float xNew = random(width/2) + width/4;
    float yNew = random(height/2) + height/4;
    for (int i = 0; i < mover.length; i++) {
      mover[i].reset();
      mover[i].start.x = xNew;
      mover[i].start.y = yNew;
      mover[i].location.x = xNew;
      mover[i].location.y = yNew;
      mover[i].mass = random(1, 6);
      //      mover[i].col = fgCol[int(random(fgCol.length))];    //preset colors
      mover[i].col = c[int(mover[i].location.x+mover[i].location.y) % c.length];   //grabbed colors
      
      PVector initForce = new PVector(random(-0.1, 0.1), random(1.0));
      mover[i].applyForce(initForce);

    };
    sides = random(6);

  }  


  for (int i = 0; i < mover.length; i++) {
    //FORCES
    //    if (mover[i].alive > 0) { 

    for (int f = 0; f < stepSize; f++) {
     
    PVector[] forces = {
      new PVector(random(-0.6,0.6), random(-0.6, 0.6)),
      new PVector(random(-0.6,0.6), random(-0.6, 0.6)),
      new PVector(random(-1,1), random(-1, 1)),
//      new PVector(0, 0.01), //gravity     
    };
   float[][] fLimits = {
     //x, y, w, h
      {0, height/3, width, height/6},
      {0, height- height/3, width, height/6}, 
      {0, 0, width, height},
//      {0, 0, width, height},
    };
   float[] frictions = {
     0.6, 
     0.6, 
     0.04,
//     0.00 
   };
   
   forces[0].mult(0.1);
   forces[1].mult(0.1);
   forces[2].mult(noise(mover[i].location.x, mover[i].location.y) * 0.2);
       
  
    for (int o = 0; o < forces.length; o++) {
      if (mover[i].isInside(fLimits[o][0], fLimits[o][1], fLimits[o][2], fLimits[o][3])) {
        mover[i].applyForce(forces[o]);
        mover[i].applyFriction(frictions[o]);
      }
    };

    mover[i].applyFriction(0.06); //GLOBAL frrriction  
//    mover[i].attract(width/2, height/2, -0.9);  //away from center
//    mover[i].attract(mover[i].start.x, mover[i].start.y, 0.6); //toward starting point


    mover[i].update();
    mover[i].clipEdges();
    //    mover[i].wrapEdges();
    };

    //DRAW
    mover[i].col = c[int((mover[i].location.x+mover[i].location.y) % c.length)];
    float sizeMod = -1;
    float size = abs(sizeMod *mover[i].velocity.mag());
//    mover[i].display(0.1*size); //faster == smaller    

    //set color of mover
    //    colorMode(HSB);
    //    mover[i].col = color(hue(c), constrain(saturation(c)+(saturation(c)*aAmpSig*0.85), 20, 255), constrain(255 * ((aFreq-160)/3000), 20, 255));  //brightness increases due to freq
    //set draw colors 
        stroke(mover[i].col, fgOp);
        strokeWeight(0.1);
      size = mover[i].thick * size;  
    //draw shape
        polygon(mover[i].location.x, mover[i].location.y, size, size, sides);
  };
}




void polygon(float x, float y, float xs, float ys, float sides) {
    pushMatrix();
    translate(x, y);
    rotate(radians((frameCount * 0.5) % 360));
    x = 0;
    y = 0;

    float lastX = x;
    float lastY = y;
    float firstX = x;
    float firstY = y;  
    for (int i = 0; i < sides; i++) {
      float angle = (TWO_PI / sides) * i;
      float x2 = x + (cos(angle) * (xs/2));
      float y2 = y + (sin(angle) * (ys/2));
      if (i == 0) { 
        firstX = x2; 
        firstY = y2;
      } else { 
        line(lastX, lastY, x2, y2);
      }
      lastX = x2;
      lastY = y2;
    };
    line(lastX, lastY, firstX, firstY);

    popMatrix();
}



void grab() {
  if (cam.available()) {
    cam.read();
    //    image(cam, 0, 0, cam.width, cam.height); //display image
    c = new color[cam.pixels.length];
    for (int i = 0; i < cam.pixels.length; i++) {
      c[i] = color(cam.pixels[i]);
    };

    //    coloravg(c);
  }
}

void load(File path) {
  println("image imported: "+path.getAbsolutePath());
  PImage img = loadImage(path.getAbsolutePath(), "png");
  //  image(img, 0, 0, img.width, img.height);
  c = new color[cam.pixels.length];
  for (int i = 0; i < img.pixels.length; i++) {
    c[i] = img.pixels[i];
  }
}

