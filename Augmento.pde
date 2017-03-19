 Ball[] balls =  { 
  new Ball(550, 250, 35),  
};

Handle[] handles =  { 
  new Handle(1150, 370, 50),
  new Handle(150, 370, 50),
};

int flick = 0;
int gameflag = 0;
int wid = 1300;
int high = 700;
int p1 = 1;
int p2 = 13;
PFont uno, dos;
PImage gif;


// import the TUIO library
import TUIO.*;
// declare a TuioProcessing client
TuioProcessing tuioClient;


void setup()
{
  // GUI setup
  noCursor();
  size(1300,700);
  noStroke();
  fill(0);
  frameRate(100);
  tuioClient  = new TuioProcessing(this);
  uno = createFont("crushed.ttf",32);
  dos = createFont("redline.ttf",32);
}




void draw()
{
    bck();
    
    if(gameflag == 1)
      {
        gamelive();
        return;
      }
      
    ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
    
    if(gameflag == 0)
    {
      for (int i=0;i<tuioObjectList.size();i++) 
      {
        TuioObject x = tuioObjectList.get(i);
        if(x.getSymbolID()==0) 
        {
          reset();
          gameflag = 1;
        }
      }
      gameopen();
      return;
    }
    
    if(gameflag == 2)
    {
      for (int i=0;i<tuioObjectList.size();i++) 
      {
        TuioObject x = tuioObjectList.get(i);
        if(x.getSymbolID()==0) 
        {
          reset();
          gameflag = 1;
        }

        if(x.getSymbolID()==4) gameflag = 0;
      }
      gameend();
      return;
    }
}



// OPEN SCREEN

void gameopen()
{
  textFont(uno);
  textSize(90);
  fill(255,255,255);
  text("AUGMENTO",150, 250);

  if(flick==0)
  {
    textFont(dos);
    textSize(40);
    fill(255,255,255);
    text("USE KEY TO START GAME",340, 350);
  }
  flick++;
  if(flick==10) flick = 0;
}



//RUNNING GAME FUNCTIONS

void gamelive()
{
  drawborder();
  TuioObject tobj1, tobj2;
  
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
    for (int i=0;i<tuioObjectList.size();i++) 
    {
      TuioObject x = tuioObjectList.get(i);
      if(x.getSymbolID()==1)
        {
        tobj1 = x;
        gameloop(tobj1, 0);
        }
      else if(x.getSymbolID()==2)
        {
        tobj2 = x;
        gameloop(tobj2, 1);
        }
        
        if(x.getSymbolID()==3) 
          gameflag = 2;
    }    
    handles[0].display(0);
    handles[1].display(1);
    balls[0].checkCollision(handles[0]);
    balls[0].checkCollision(handles[1]);
    balls[0].update();
    balls[0].display();
    balls[0].checkBoundaryCollision();
}

void gameloop(TuioObject tobj, int i)
{
     if(balls[0].position.x > tobj.getScreenX(wid))
     {  
       if(balls[0].position.y < tobj.getScreenY(high))
         handles[i].update(tobj,1);
       else
         handles[i].update(tobj,4);
     }
     else
     {
       if(balls[0].position.y < tobj.getScreenY(high))
         handles[i].update(tobj,2);
       else
         handles[i].update(tobj,3);
     }
     //ellipse(tobj.getScreenX(1000), tobj.getScreenY(800),100,100);
}



//GAME END SCORE SHEET

void gameend()
{
  int k=0;
  if(p1>3)
  {  k=wid-330;
    fill(220,50,70);
  rect(0,0,wid/2,high);}
  else if(p2>3)
    {k=350;
     fill(50,220,70);
   rect(wid/2,0,wid/2+5,high);}
textFont(uno);
  textSize(30);
  textAlign(CENTER);
  
  text("YOU WON \nCONGRATULATIONS!!",k, high/2+40);
  
}

float [] x= {100,100,100,100,100,100,100,100,100,200,200,200,200,200,200,200,200,200,300,300,300,300,300,300,300,300,300,400,400,400,400,400,400,400,400,400,500,500,500,500,500,500,500,500,500,600,600,600,600,600,600,600,600,600,700,700,700,700,700,700,700,700,700,800,800,800,800,800,800,800,800,800,900,900,900,900,900,900,900,900,900,900,1000,1000,1000,1000,1000,1000,1000,1000,1000,1100,1100,1100,1100,1100,1100,1100,1100,1100,1200,1200,1200,1200,1200,1200,1200,1200,1200};
float [] y={50,100,150,200,250,300,350,400,450,50,100,150,200,250,300,350,400,450,50,100,150,200,250,300,350,400,450,50,100,150,200,250,300,350,400,450,50,100,150,200,250,300,350,400,450,50,100,150,200,250,300,350,400,450,50,100,150,200,250,300,350,400,450,50,100,150,200,250,300,350,400,450,50,100,150,200,250,300,350,400,450,50,100,150,200,250,300,350,400,450,500,550,600,650,700, 750};

float [] xdelta ={2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,};
float [] ydelta ={2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,2,-2,};

void bck()
{
background(0);
fill(256,257,256);
stroke(1,1,150);;
strokeWeight(2);

for (int i=0; i<89;i++)
{
  ellipse(x[i],y[i],4,4);
  x[i] = x[i]+ xdelta[i]*2;
  y[i] = y[i]+ ydelta[i]*2;
  
  if ( (x[i]>width -2) ||  (x[i] < 10) )
  {
    xdelta[i]= -xdelta[i];
  }
  
  if ( (y[i]>height -2) ||  (y[i] < 10) )
  {
    ydelta[i]= -ydelta[i];
  }
}
if(gameflag==1)
showscore();

}

void showscore()
{
  textFont(uno);
  textSize(100);
  textAlign(CENTER);
  fill(70,70,70);
  text(p2,wid/2-300, high/2+40);
  text(p1,wid/2+300, high/2+40); 
}
//RESET ALL FOR NEW GAME FUNCTION

void reset()
{
p1=0;
p2=0;
}



//DRAW BORDER FUNCTION
int Y_AXIS = 10;
int X_AXIS = 2;
color b1, b2, c1, c2;

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}
void drawborder()
{
  b1 = color(255,0,0);
  b2 = color(0);
  
  c1 = color(0, 255, 0);
  c2 = color(0, 0, 255);

fill(200,200,200);
stroke(100);
//line(50,high/2-50,50,50);
setGradient(50, 50, (wid-100)/2, 5, b2, c1, Y_AXIS);
  setGradient(50, 55, (wid-100)/2, 5, c1, b2, Y_AXIS);

setGradient((wid-50)/2, 50, (wid-50)/2, 5, b2, b1, Y_AXIS);
  setGradient((wid-50)/2, 55, (wid-50)/2, 5, b1, b2, Y_AXIS);

setGradient(50, 50, 5, (high/2)-130, b2, c1, X_AXIS);
  setGradient(55, 50, 5, (high/2)-130, c1, b2, X_AXIS);

setGradient(50, (high/2)+120, 5, (high/2)-170, b2, c1, X_AXIS);
  setGradient(55, (high/2)+120, 5, (high/2)-170, c1, b2, X_AXIS);

setGradient(50, high-50, (wid-50)/2, 5, b2, c1, Y_AXIS);
  setGradient(50, high-45, (wid-50)/2, 5, c1, b2, Y_AXIS);

setGradient((wid-50)/2, (high)-50, (wid-40)/2, 5, b2, b1, Y_AXIS);
  setGradient((wid-50)/2, (high)-45, (wid-40)/2, 5, b1, b2, Y_AXIS);

setGradient(wid-50, 50, 5, (high/2)-130, b2, b1, X_AXIS);
  setGradient(wid-45, 50, 5, (high/2)-130, b1, b2, X_AXIS);

setGradient(wid-50, (high/2)+120, 5, (high/2)-170, b2, b1, X_AXIS);
  setGradient(wid-45, (high/2)+120, 5, (high/2)-170, b1, b2, X_AXIS);

/*
line(50,high/2+50,50,high-50);
line(wid-50,high/2-50,wid-50,50);
line(wid-50,high/2+50,wid-50,high-50);
line(50,50,(wid-50)/2,50);
line((wid-50)/2,50,(wid-50),50);
line(50,high-50,(wid-50)/2,high-50);
line((wid-50)/2,high-50,wid-50,high-50);
*/
}