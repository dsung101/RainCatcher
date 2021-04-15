 //Rain Catcher Game -- Daniel Sung
 Hunter hunter;  /// the hunter
 GoldenBall goldenBall;  // the golden ball
 Attacker attacker1;  // attacker1
 Attacker attacker2; // attacker2
// Bludger fred;
 //Bludger george;
 Catcher catcher;  /// the catcher
 Timer droptimer; // interval between each droplet
 Timer gametimer; // how long you played the game
 Timer gbtimer; // when golden ball comes in 
 Drop[] drops;   /// the array of droplets
 BadDrop[] badDrops;  // bad droplets
 int totalDrops = 0;  //total rain drops
 int score; // counts points
 boolean gameOn = true;
 int level = 0;
 
 void setup() {
   size(900, 900);  // 900 by 900 plane
   smooth();
   score = 0;  // score is 0 at start
   catcher = new Catcher(32); 
   hunter = new Hunter(mouseX,mouseY);
   drops = new Drop[1000];
   badDrops = new BadDrop[1000];
   goldenBall = new GoldenBall();
   attacker1 = new Attacker();
   attacker2 = new Attacker();
   gbtimer = new Timer(5000);
   gbtimer.start();  // starts timer of 15 seconds at start of game before golden ball spawns
   droptimer = new Timer(1000);
   droptimer.start();
 }
 
 void draw() {
   if (gameOn) {
     if (catcher.goldintersect(goldenBall) || score == 150) {  // winner screen pops up if catcher gets the golden ball
       goldenBall.caught();
       Winner(); 
       gameOn = false;
     }
   /*if (catcher.hunterintersect(hunter))  { // loser screen pops up if hunter catches the catcher
       score = 0;
       Loser(); 
       gameOn = false;
     }*/
   background(255);
   fill(0);
   textSize(20);
   textAlign(CENTER);
   text("RainCatcher Game -- Daniel Sung", 450, 25);   /// title
   text("Timer: " + (int)millis()/1000, 50, 875);  // timer on bottom left corner
   text("Score: " + score, 800, 875);  // score board on bottom right corner
   catcher.setLocation(mouseX, mouseY);  // catcher location
   catcher.display();  // displays catcher 
   hunter.move();  // hunter moves towards mouseX and mouseY
   hunter.display();  // displays the hunter
   attacker1.display();  // displays attacker1
   attacker2.display();  // ""
   attacker1.move();   // moves attacker1
   attacker2.move();  // ""
   getLevel(score);
   if (droptimer.isFinished()) {  // if 1 second passes
     drops[totalDrops] = new Drop();  // form a new droplet
     badDrops[totalDrops] = new BadDrop();  // form a new bad droplet
     totalDrops++;  // increases number of total drops
     if (totalDrops > drops.length)  // reset totaldrops if it exceeds 1000
       totalDrops = 0;
     droptimer.start();
   }
   if (level ==5) {  /// move and display the golden ball
     goldenBall.move();
     goldenBall.display();

   }
   for (int i = 0; i<totalDrops; i++) {  // move and display regular and bad droplets
     drops[i].move();
     drops[i].display();
     badDrops[i].move();
     badDrops[i].display();
     if (catcher.intersect(drops[i])) {  // 10 points added if catcher gets a regular droplet
       drops[i].caught();
       score+=10;
     }
     if (catcher.intersects(badDrops[i])) {  // -10 points if catcher gets a bad droplet
       badDrops[i].caught();
       score-=10;
     }
     if (catcher.attackintersect(attacker1) || catcher.attackintersect(attacker2)) {  // everytime the catcher hits the two attackers it subtracts 10 points from score
       score-=10;
       attacker1.x = random(width);
       attacker2.x = random(width);
     }
   }
   }
   else {
     if (keyPressed)
       restartGame();
     }
 }
 
 // Restart Method
 void gameOn() {
   if (catcher.goldintersect(goldenBall)) 
     gameOn = false;
   if (catcher.hunterintersect(hunter))
     gameOn = false;
   gameOn = true;
 }
 
 
 
 //// CATCHER CODE
 class Catcher {
 float r;
 float x, y;
 color c;
 Catcher(float tempr){
   r = tempr;
   x = 0;
   y = 0;
   c = color(50, 10, 10, 150);
 }
 void setLocation(float tempx, float tempy) {
   x = tempx;
   y = tempy;
 }
 void display() {
   stroke(0);
   fill(c);
   ellipse(x, y, 2*r, 2*r);
 }
 boolean intersect(Drop d) {
   float distance = dist(x, y, d.x, d.y); 
   if (distance < r+d.r) 
     return true;
   else
     return false;
 }
 boolean intersects(BadDrop b) {
   float distance = dist(x, y, b.x, b.y);
   if (distance < r+b.r)
     return true;
   else
     return false;
 }
 boolean goldintersect(GoldenBall g) {
   float distance = dist(x, y, g.x, g.y);
   if (distance < r+g.r)
     return true;
   else
     return false;
 }
 boolean attackintersect(Attacker a) {
   float distance = dist(x, y, a.x, a.y);
   if (distance < r+a.r)
     return true;
   else
     return false;
 }
 boolean hunterintersect(Hunter h) {
   float distance = dist(x, y, h.x, h.y);
   if (distance < r+h.r)
     return true;
   else
     return false;
 }
}
 
 
 ///// DROPLET CODE
class Drop {
  float x,y;
  float speed;
  float r;
  color col; 
  Drop() {
    r = 8;
    x = random(width);
    y = -r*4;
    speed = random(1,5);
    col = color(50, 100, 150);
  }
  void move() {
    y+=speed;
  }
  boolean reachedBottom() {
    if (y>height+r*4)
      return true;
    else
      return false;
  }
  void display() {
    fill(col);
    noStroke();
    for (int i = 2; i<r; i++) {
      ellipse(x, y+i*4, i*2, i*2);
    }
  }
  void caught() {
    speed = 0;
    y = -1000;
  }
}
 
 
 
 
 //// Bad Droplet CODE
 class BadDrop {
  float x,y;
  float speed;
  float r;
  color col; 
  BadDrop() {
    r = 8;
    x = random(width);
    y = -r*4;
    speed = random(1,5);
    col = color(255, 0, 0);
  }
  void move() {
    y+=speed;
  }
  boolean reachedBottom() {
    if (y>height+r*4)
      return true;
    else
      return false;
  }
  void display() {
    fill(col);
    noStroke();
    for (int i = 2; i<r; i++) {
      ellipse(x, y+i*4, i*2, i*2);
    }
  }
  void caught() {
    speed = 0;
    y = -1000; 
  }
}



/// golden ball code
class GoldenBall {
  float r;
  float x,y; 
  float xspeed; 
  float yspeed;
  float xdirection;
  float ydirection;
  color c;
  GoldenBall() {
    r = 6;
    x = random(width);
    y = random(height);
    xspeed = 6;
    yspeed = 6;
    xdirection = random(1,5);
    ydirection = random(1,5);
    c = color(225, 223, 0);
  }
  void move() {
    x+=xspeed*xdirection;
    y+=yspeed*ydirection;
    if (x>=width-r || x<=r)
      xdirection*=-1;
    if (y>=height-4 || y<=r)
      ydirection*=-1;
  }
  void display() {
    fill(c);
    noStroke();
    ellipse(x, y, 2*r, 2*r);
  }
  void caught() {
    xspeed = 0;
    yspeed = 0;
    y = -1000;
  }
}



//// TIMER CODE
class Timer {
  int savedTime;
  int totalTime;
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }
  void start() {
    savedTime = millis();
  }
  boolean isFinished() {
    int passedTime = millis() - savedTime;
    if (passedTime>totalTime)
      return true;
    else
      return false;
  }
}


/// ATTACK BALL CODE
class Attacker {
  float r;
  float x;
  float y;
  float xspeed;
  float yspeed;
  float xdirection;
  float ydirection;
  color c;
  Attacker() {
    r = 50;
    x = random(width);
    y = random(height);
    xspeed = 4;
    yspeed = 4;
    xdirection = 2;
    ydirection = 2;
    c = color(210, 105, 30);
  }
  void move() {
    x+=xspeed*xdirection;
    y+=yspeed*ydirection;
    if (x>=width-r || x<=r)
      xdirection*=-1;
    if (y>=height-4 || y<=r)
      ydirection*=-1;
  }
  void display() {
    fill(c);
    noStroke();
    ellipse(x, y, 2*r, 2*r);
  }
}



//// HUNTER CODE
class Hunter {
  float r;
  float x, y;
  color c;
  float easing;
  float targetx;
  float targety;
  Hunter(float x, float y) {
    r = 30;
    easing = 0.025;
    targetx = x;
    targety = y;
    c = color(255, 69, 0);
  }
  void move() {
    float targetX = mouseX;
    float dx = targetX - x;
    x += dx * easing;
  
    float targetY = mouseY;
    float dy = targetY - y;
    y += dy * easing;
  }
  void display() {
    fill(c);
    noStroke();
    ellipse(x, y, r*2, r*2);
  }
}

void getLevel(int score) {
  if (score>100) 
    level = 5;
  else if (score>80)
    level = 4;
  else if (score>60)
    level = 3;
  else if (score>30)
    level = 2;
  else
    level = 1;
}


/// WIN or LOSE code

void Winner() {
  background(255);
  textAlign(CENTER);
  textSize(75);
  fill(0);
  text("YOU WIN! Score: " + score, 450, 450);
}

void Loser() {
  background(255);
  textAlign(CENTER);
  textSize(100);
  text("YOU LOSE!", 450, 450);
}

void restartGame() {
  gbtimer.start();
  droptimer.start();
  level = 1;
  score = 0;
}
