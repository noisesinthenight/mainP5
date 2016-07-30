class Mover {
  //  int startx, starty;
  PVector start, location, velocity, accel;
  float mass = 1;
  int maxVelocity = 100;

  int alive = 1, stepCount = 0, stepMax = 500;

  color col;
  float thick = 1, opacity = 200;

  Mover(float x, float y, float m) {
    start = new PVector(x, y);
    location = new PVector(x, y);
    mass = m;
    velocity = new PVector(0, 0);
    accel = new PVector(0, 0);
    col = 20;
  }

  void reset() {
    //location = new PVector(x, y);
    velocity.mult(0);
    accel.mult(0);
    stepCount = 0;
    alive = 1;
  }

  boolean isInside(float x, float y, float w, float h) {
    if ((location.x > x  &&  location.x < (x+w))  &&  (location.y > y  &&  location.y < y+h)) {
      return true;
    } else {
      return false;
    }
  }


  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass); //ACCELERATION = FORCE / MASS
    accel.add(f);
  }

  void applyFriction(float coeff) {
    float speed = velocity.mag();
    PVector drag = velocity.get();
    drag.mult(-1);
    drag.normalize();
    drag.mult(coeff * (speed*speed));
    applyForce(drag);
  }

  void attract(float x, float y, float m) {
    PVector aLoc = new PVector(x, y);
    PVector aForce = PVector.sub(aLoc, location); 
    float distance = aForce.mag(); 
    distance = constrain(distance, 5.0, 25.0);
    aForce.normalize();
    float strength = (mass*m) / (distance * distance);
    aForce.mult(strength);
    applyForce(aForce);
  }


  void update() {
    velocity.add(accel);
    velocity.limit(maxVelocity);
    location.add(velocity);
    accel.mult(0);
    stepCount++;
    if (stepCount > stepMax) { alive = 0; };
  }



  void wrapEdges() {    
    if (location.x < 0) {        
      location.x = width;
    } else if (location.x > width) {
      location.x *= 0;
    };

    if (location.y < 0) {
      location.y = height;
    } else if (location.y > height) {
      location.y = 0;
    };
  }
  
  void clipEdges() {
    if (location.x < 0) {        
      velocity.x *= -1;
      location.x = 0;
    } else if (location.x > width) {
      velocity.x *= -1;
      location.x = width;
    };

    if (location.y < 0) {
      velocity.y *= -1;
      location.y = 0;
    } else if (location.y > height) {
      velocity.y *= -1;
      location.y = height;
    };
  }


  void display(float size) {
    stroke(col, opacity);
    fill(col, opacity);
    ellipse(location.x, location.y, mass*size, mass*size);
  }
}

