//CLASS DEFINITIONS

class Handle {
  PVector position;
  PVector prev;
  PVector velocity;

  float r, m;

  Handle(float x, float y, float r_) {
    position = new PVector(x, y);
    prev = new PVector(x,y);
    velocity = new PVector(0,0);
    r = r_;
    m = r*.1;
  }

  void update(TuioObject tobj, int x) {
    prev = position;
    int k = 5;
    position.x = tobj.getScreenX(wid);
    position.y = tobj.getScreenY(high);
    switch(x)
    {
    case 1 : velocity.x=k; velocity.y=-k;
    break;
    case 2 : velocity.x=-k; velocity.y=-k;
    break;
    case 3 : velocity.x=-k; velocity.y=k;
    break;
    case 4 : velocity.x=k; velocity.y=-k;
    break;
    }
    //velocity.y = (position.y - prev.y)*100+3;
  }

  void dump()
  {
    velocity.x = 0;
    velocity.y = 0;
  }
  
  void display(int x) {
    noStroke();
    colorMode(HSB, 360, 100, 100);
    //ellipseMode(RADIUS);
    float h,k;
    if(x==0)
    {h = 455; k=10;}
    else
    {h=10; k=455;}
  int radius= int(r);
  for (int ra = radius; ra > 0; --ra) {
    fill(h,k, h%135);
    ellipse(position.x, position.y, ra*2, ra*2);
    h = h + 5 % 360;
    colorMode(RGB, 360, 100, 100);
  } 
      //ellipse(position.x, position.y, r*2, r*2);
  }
}


class Ball {
  PVector position;
  PVector velocity;

  float r, m;

  Ball(float x, float y, float r_) {
    position = new PVector(x, y);
    velocity = PVector.random2D();
    velocity.x+=4;
    velocity.y+=4;
    velocity.mult(3);
    r = r_;
    m = r*.1;
  }

  void update() {
    position.add(velocity);
  }

  void checkBoundaryCollision() {
    if(!((position.y+r<=(high/2+120) && position.y-r>=(high/2-120)) && (position.x <= r+50 || position.x >= width-r-50) ))
    {
    if (position.x > width-r-50) {
      position.x = width-r-50;
      velocity.x *= -1;
    } 
    else if (position.x < r+50) {
      position.x = r+50;
      velocity.x *= -1;
    } 
    else if (position.y > height-r-50) {
      position.y = height-r-50;
      velocity.y *= -1;
    } 
    else if (position.y < r+50) {
      position.y = r+50;
      velocity.y *= -1;
    }
    }
    else
    {
    if (position.x < r+50) p1++;
    else if (position.x > width-r-50) p2++;
    
    if(p1>3 || p2>3)
      gameflag=2;
      
    position.x=wid/2;
    position.y=high/2;
    velocity = PVector.random2D();
    velocity.x += 3;
    velocity.y += 3;
    velocity.mult(3);
    }
  }


  void checkCollision(Handle other) {

    // get distances between the balls components
    PVector bVect = PVector.sub(other.position, position);

    // calculate magnitude of the vector separating the balls
    float bVectMag = bVect.mag();

    if (bVectMag < r + other.r) {
      // get angle of bVect
      float theta  = bVect.heading();
      // precalculate trig values
      float sine = sin(theta);
      float cosine = cos(theta);

      /* bTemp will hold rotated ball positions. You 
       just need to worry about bTemp[1] position*/
      PVector[] bTemp = {
        new PVector(), new PVector()
        };

        /* this ball's position is relative to the other
         so you can use the vector between them (bVect) as the 
         reference point in the rotation expressions.
         bTemp[0].position.x and bTemp[0].position.y will initialize
         automatically to 0.0, which is what you want
         since b[1] will rotate around b[0] */
        bTemp[1].x  = cosine * bVect.x + sine * bVect.y;
      bTemp[1].y  = cosine * bVect.y - sine * bVect.x;

      // rotate Temporary velocities
      PVector[] vTemp = {
        new PVector(), new PVector()
        };

        vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
      vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
      vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      /* Now that velocities are rotated, you can use 1D
       conservation of momentum equations to calculate 
       the final velocity along the x-axis. */
      PVector[] vFinal = {  
        new PVector(), new PVector()
        };

      // final rotated velocity for b[0]
      vFinal[0].x = ((m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (m + other.m);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((other.m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + other.m);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      /* Rotate ball positions and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
      PVector[] bFinal = { 
        new PVector(), new PVector()
        };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      // update balls to screen position
      other.position.x = position.x + bFinal[1].x;
      other.position.y = position.y + bFinal[1].y;

      position.add(bFinal[0]);

      // update velocities
      velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;
      velocity.x += 3;
      velocity.y += 3;
    }    
    other.dump();
  
  }

  void display() {
    noStroke();
    fill(251,251,351);
    ellipse(position.x, position.y, r*2, r*2);
    fill(10,10,251);
    ellipse(position.x, position.y, r*2-10, r*2-10);
    
  }
}