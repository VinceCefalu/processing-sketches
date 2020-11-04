// Dumb little game made to learn about game loops and win-conditions


// 0: Initial screen
// 1: Game screen
// 2: Game Over screen

int gameScreen = 0;
Line player;
Point point;
int score = 0;
int speedupThresh = 3;

void setup() {
   size(400, 400);
   frameRate(30);
}

void draw() {
   if (gameScreen == 0) {
      initScreen();
   } else if (gameScreen == 1) {
      gameScreen();
   } else if (gameScreen == 2) {
      gameOverScreen();
   }
}

//////////////////
// GAME SCREENS //
//////////////////
void initScreen() {
   background(0);
   fill(255);
   textAlign(CENTER);
   text("Click to start!", width/2, height/2);
   text("Controls:\nClick! (Or Spacebar)\n\nRed = Speed up\nHit the wall = Game Over!", width/2, height/2 + 30);
}

void gameScreen() {
   background(245);
   fill(0);
   textAlign(CENTER);
   text("Score: " + score, width/2, 10);
   text("Speed: " + player.getSpeed(), width/2, 20);
   
   player.draw();
   point.draw();
   
   if (intersected(player, point)) {
      score += point.getValue();
      if (score % speedupThresh == 0) {
         player.speedUp();
      }
      spawnPoint();
   }
   
   if (player.offScreen()) {
      gameScreen = 2;
   }
}

void gameOverScreen() {
   background(0);
   fill(255);
   textAlign(CENTER);
   text("Game Over!\nYour score was " + score + " points", width/2, height/2);
}

///////////
// INPUT //
///////////
public void mousePressed() {
   if (gameScreen == 0) {
      player = new Line();
      score = 0;
      spawnPoint();
      gameScreen = 1;
   } else if (gameScreen == 1) {
      // Click is anchor line
      player.swap();
   } else if (gameScreen == 2) {
      gameScreen = 0;
   }
}

public void keyPressed() {
   switch(key) {
      case 32: player.swap(); break;
      default: break;
   }
}

///////////
// OTHER //
///////////
void spawnPoint() {
   int offset = 15;
   if ((score + 1) % speedupThresh == 0) {
      point = new Point(1, new PVector(random(0, width), random(0, height)), true);
   } else {
      point = new Point(1, new PVector(random(0, width), random(0, height)), false);
   }
   if (point.getLocation().x < offset || point.getLocation().y < offset ||
   point.getLocation().x > width-offset || point.getLocation().y > height-offset) {
      spawnPoint();
   }
}

boolean intersected(Line player, Point point) {
   if ((int)(dist(player.getStartPoint().x, player.getStartPoint().y, point.getLocation().x, point.getLocation().y) + 
   dist(player.getEndPoint().x, player.getEndPoint().y, point.getLocation().x, point.getLocation().y)) == 
   player.getRadius()) {
      return true;
   }
   return false;
}
