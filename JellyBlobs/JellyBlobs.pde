/** Based on the Jelly Blobs of Doom Neopets game though these
* aren't really blobs since I wanted to keep the collision simple and
* predictable for my own learning's sake
* Eat anything smaller than you and dodge what's bigger than you or be eaten!
*
* Interesting thing about this game is how in the beginning, the struggle is to
* be able to actully eat something with your small size, though dodging big ones
* is easy. Then as you grow, the challege reverses.
**/

int lastTick, tickLength;

int gameScreen;
int colorIndex;
PVector[] colors;

ArrayList<EnemyBlob> blobs;
PlayerBlob p;
InputBuffer input;

void setup() {
   frameRate(60);
   size(600, 400);
   
   colors = new PVector[5];
   colors[0] = new PVector(240, 240, 240);
   colors[1] = new PVector(50, 255, 50);
   colors[2] = new PVector(135, 206, 250);
   colors[3] = new PVector(240, 120, 20);
   colors[4] = new PVector(240, 60, 60);
   
   colorIndex = 0;
}



//////////////////////
//   GAME SCREENS   //
//////////////////////

void initScreen() {
   background(130);
   fill(255);
   textAlign(CENTER);
   text("Controls:\nW = UP\nA = LEFT\nS = DOWN\nD = RIGHT\n\nPress Space to begin!", width/2 - 5, height/2 - 50);
   text("Choose a color with A or D!", width / 2, height / 2 + 100);
   noStroke();
   fill(colors[colorIndex].x, colors[colorIndex].y, colors[colorIndex].z);
   rect(width / 2 - 15, height / 2 + 55, 15, 15);
}

void gameScreen() {
   background(130);
   
   if (lastTick + tickLength <= millis()) {
      lastTick = millis();
      spawnBlob(); //<>//
   }
   
   updateBlobs();
   killBlobs();
   drawBlobs();
   updatePlayer();
   if (p.movementEnabled())
      p.move();
   p.draw();
}

void loseScreen() {
   textSize(28);
   fill(255);
   textAlign(CENTER);
   text("You were eaten!\n\nYou ate: " + (p.getSize() - 3) + " blobs!", width / 2, height / 2 - 30);
   
   textSize(12);
   text("Press space to start again!", width / 2, height - 50);
}



/////////////////
//   DRAWING   //
/////////////////

void draw() {
   if (gameScreen == 0) {
      initScreen();
   } else if (gameScreen == 1) {
      gameScreen();
   } else if (gameScreen == 2) {
      loseScreen();
   }
}

void drawBlobs() {
   for (EnemyBlob b : blobs) {
      b.draw();
   }
} 

///////////////
//   INPUT   //
///////////////

void keyPressed() {  
   switch(key) {
      case 32: { // SPACE
         if (gameScreen == 0) {
            gameScreen = 1;
            initGame();
         } else if (gameScreen == 1) {
            p.eat();
         } else if (gameScreen == 2) {
            gameScreen = 1;
            initGame();
         }
         break;
      }
      case 119: { // w
         if (gameScreen == 1)
            input.add(119);
         break;
      }      
      case 115: { // s
         if (gameScreen == 1)
            input.add(115);
         break;
      }
      case 97: { // a
         if (gameScreen == 0) {
            colorIndex--;
            if (colorIndex < 0)
               colorIndex = colors.length - 1;
         }
         if (gameScreen == 1)
            input.add(97);
         break;
      }
      case 100: { // d
         if (gameScreen == 0) {
            colorIndex++;
            if (colorIndex >= colors.length)
               colorIndex = 0;
         }
         if (gameScreen == 1)
            input.add(100);
         break;
      }
      case CODED: { // UP AND DOWN ARROWS
         break;
      }
      
      default: {
         print("KEY NOT RECOGNIZED");
      }
   } 
}

void keyReleased() {
   //print(millis() + " " + key + " released\n");
   switch(key) {
      case 119: { // W
         if (gameScreen == 1)
            input.remove(119);
         break;
      }      
      case 115: { // S
         if (gameScreen == 1)
            input.remove(115);
         break;
      }
      case 97: { // A
         if (gameScreen == 1)
            input.remove(97);
         break;
      }
      case 100: { // D
         if (gameScreen == 1)
            input.remove(100);
         break;
      }
      case CODED: { // UP AND DOWN ARROWS
         break;
      }
      
      default: {
         
      }
   }
   //print(millis() + " REMOVED: " + key + "\n");
   //print(millis() + " [" + input.getBuffer()[0] + ", " + input.getBuffer()[1] + "]\n");
}



///////////////
//   OTHER   //
///////////////

void initGame() {
   p = new PlayerBlob();
   blobs = new ArrayList<EnemyBlob>();
   input = new InputBuffer();
   
   lastTick = millis();
   tickLength = 1000;
}

void spawnBlob() {
   PVector direction, location;
   int size = (int)random(p.getSize() + 15) + 2;
   if (random(100) > 50) {
      direction = new PVector(1, 0);
      location = new PVector(-size, random(height - size / 2) + 2);
   } else {
      direction = new PVector(-1, 0);
      location = new PVector(width, random(height - size / 2) + 2);
   }
   blobs.add(new EnemyBlob((int)random(3) + 1, size, direction, location));
}

void updateBlobs() {
   for (EnemyBlob b : blobs) {
      if (!p.isEaten()) {
         checkCollisions(b, p);
      }
      b.move();
      if (b.atePlayer()) {
         PVector location = new PVector(b.getLocation().x + b.getSize() / 2 - p.getSize() / 2,
                                       b.getLocation().y + b.getSize() / 2 - p.getSize() / 2);
         p.setLocation(location);
      }
   }
}

void updatePlayer() {
   PVector direction = new PVector(0.0f, 0.0f);
   float acceleration = 0.1f;
   
   if (input.contains(119)) {
      direction.y = -acceleration;
   }
   
   if (input.contains(115)) {
      direction.y = acceleration;
   }
   
   if (input.contains(97)) {
      direction.x = -acceleration;
   }
   
   if (input.contains(100)) {
      direction.x = acceleration;
   }
   p.setDirection(direction);
}

void killBlobs() {
   for (int i = 0; i < blobs.size(); i++) {
      if (blobs.get(i).isEaten()) {
         blobs.remove(i);
         continue;
      }
      
      if (blobs.get(i).getDirection().x == 1) {
         if (blobs.get(i).getLocation().x > width) {
            if (blobs.get(i).atePlayer()) {
               gameScreen = 2;
            }
            blobs.remove(i);
         }
      } else if (blobs.get(i).getDirection().x == -1) {
         if (blobs.get(i).getLocation().x + blobs.get(i).getSize() < 0) {
            if (blobs.get(i).atePlayer()) {
               gameScreen = 2;
            }
            blobs.remove(i);
         }
      }
   }
}

void checkCollisions(EnemyBlob b, PlayerBlob p) {
   boolean collision = false;
   // first check if p is in b
   if (p.getLocation().x + p.getSize() >= b.getLocation().x && p.getLocation().x <= b.getLocation().x + b.getSize()) {
      if (p.getLocation().y + p.getSize() >= b.getLocation().y && p.getLocation().y <= b.getLocation().y + b.getSize()) {
         // p inside b
         collision = true;
      }
   } else if (b.getLocation().x + b.getSize() >= p.getLocation().x && b.getLocation().x <= p.getLocation().x + p.getSize()) {
      if (b.getLocation().y + b.getSize() >= p.getLocation().y && b.getLocation().y <= p.getLocation().y + p.getSize()) {
         // b inside p
         collision = true;
      }
   }
   
   if (collision) {
      if (p.getSize() >= b.getSize()) {
         b.getEaten();
         p.eat();
         if (p.getSize() % 5 == 0)
            tickLength -= 50;
      } else {
         p.getEaten();
         b.eat();
      }
   }
}
