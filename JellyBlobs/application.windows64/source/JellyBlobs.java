import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class JellyBlobs extends PApplet {

int lastTick, tickLength;

int gameScreen;
int colorIndex;
PVector[] colors;

ArrayList<EnemyBlob> blobs;
PlayerBlob p;
InputBuffer input;

public void setup() {
   frameRate(60);
   
   
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

public void initScreen() {
   background(150);
   textAlign(CENTER);
   text("Controls:\nW = UP\nA = LEFT\nS = DOWN\nD = RIGHT\n\nPress Space to begin!", width/2, height/2 - 50);
   //text("Choose a color with A or D!", width / 2, height / 2 + 60);
}

public void gameScreen() {
   background(150);
   //fill(colors[colorIndex].x, colors[colorIndex].y, colors[colorIndex].z);
   
   if (lastTick + tickLength <= millis()) {
      lastTick = millis();
      spawnBlob();
   }
   
   updateBlobs();
   killBlobs();
   drawBlobs();
   updatePlayer();
   if (p.movementEnabled())
      p.move();
   p.draw();
}

public void loseScreen() {
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

public void draw() {
   if (gameScreen == 0) {
      initScreen();
   } else if (gameScreen == 1) {
      gameScreen();
   } else if (gameScreen == 2) {
      loseScreen();
   }
}

public void drawBlobs() {
   for (EnemyBlob b : blobs) {
      b.draw();
   }
} 

///////////////
//   INPUT   //
///////////////

public void keyPressed() {  
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
      case 119: { // W
         if (gameScreen == 1)
            input.add(119);
         break;
      }      
      case 115: { // S
         if (gameScreen == 1)
            input.add(115);
         break;
      }
      case 97: { // A
         if (gameScreen == 1)
            input.add(97);
         break;
      }
      case 100: { // D
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

public void keyReleased() {
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

public void initGame() {
   p = new PlayerBlob();
   blobs = new ArrayList<EnemyBlob>();
   input = new InputBuffer();
   
   lastTick = millis();
   tickLength = 1000;
}

public void spawnBlob() {
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

public void updateBlobs() {
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

public void updatePlayer() {
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

public void killBlobs() {
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

public void checkCollisions(EnemyBlob b, PlayerBlob p) {
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
class Blob {
   int maxSpeed;
   float speedX, speedY;
   int size;
   PVector direction;
   PVector location;
   float friction;
   boolean isEaten;
   boolean movementEnabled;
   
   public Blob() {
      maxSpeed = 2;
      size = 3;
      direction = new PVector(1, 0);
      location = new PVector(0, height / 2);
      friction = 0.03f;
      isEaten = false;
      movementEnabled = true;
   }
   
   public Blob(int maxSpeed, int size, PVector direction, PVector location) {
      this.maxSpeed = maxSpeed;
      this.size = size;
      this.direction = direction;
      this.location = location;
      
      isEaten = false;
      friction = 0.05f;
   }
   
   public void move() {
      if (direction.x != 0.0f) {
         speedX += direction.x;
         if (speedX > maxSpeed) {
            speedX = maxSpeed;
         } else if (speedX < -maxSpeed) {
            speedX = -maxSpeed;
         }
      } else { // apply friction
         if (speedX > 0.0f) {
            speedX -= friction;
            if (speedX < 0.0f)
               speedX = 0.0f;
         } else if (speedX < 0.0f) {
            speedX += friction;
            if (speedX > 0.0f)
               speedX = 0.0f;
         }
      }
      
      if (direction.y != 0.0f) {
         speedY += direction.y;
         if (speedY > maxSpeed) {
            speedY = maxSpeed;
         } else if (speedY < -maxSpeed) {
            speedY = -maxSpeed;
         }
      } else { // apply friction
         if (speedY > 0.0f) {
            speedY -= friction;
            if (speedY < 0.0f)
               speedY = 0.0f;
         } else if (speedY < 0.0f) {
            speedY += friction;
            if (speedY > 0.0f)
               speedY = 0.0f;
         }
      }
      
      location.x += speedX;
      location.y += speedY;
   }
   
   public void draw() {
      noStroke();
      fill(138, 43, 226); //poiple
      rect(location.x, location.y, size, size);
   }
   
   public void setLocation(PVector location) {
      this.location = location;
   }
   
   public void setDirection(PVector direction) {
      this.direction = direction;
   }
   
   public void getEaten() {
      isEaten = true;
      movementEnabled = false;
   }
 
   public boolean isEaten() { return isEaten; }
   public PVector getLocation() { return location; }
   public int getSize() { return size; }
   public PVector getDirection() { return direction; }
   public boolean movementEnabled() { return movementEnabled; }
}
class EnemyBlob extends Blob {
   boolean atePlayer;
   
   public EnemyBlob() {
      super();
      location.x = width / 2;
      atePlayer = false;
   }
   
   public EnemyBlob(int speed, int size, PVector direction, PVector location) {
      super(speed, size, direction, location);
      atePlayer = false;
   }
   
   public void eat() {
      atePlayer = true;
   }
   
   public void draw() {
      noStroke();
      fill(138, 43, 226); //poiple
      rect(location.x, location.y, size, size);
   }
   
   public boolean atePlayer() { return atePlayer; }
}
class InputBuffer {
   int[] buffer = { -1, -1 };
   int last;
   
   public InputBuffer() {
      last = 0;
   }
   
   public void add(int inputKey) {
      if (buffer[0] != inputKey && buffer[1] != inputKey) {
         last = (last == 0) ? 1 : 0;
         buffer[last] = inputKey;
      }
   }
   
   public void remove(int inputKey) {
      if (buffer[0] == inputKey) {
         buffer[0] = -1;
         last = 1;
      }
      if (buffer[1] == inputKey) {
         buffer[1] = -1;
         last = 0;
      }
   }
   
   public boolean contains(int inputKey) {
      return buffer[0] == inputKey || buffer[1] == inputKey;
   }
   
   public void clear() {
      buffer[0] = -1;
      buffer[1] = -1;
   }
   
   public int[] getBuffer() { return buffer; }
}
class PlayerBlob extends Blob {
   float friction;
   
   public PlayerBlob() {
      super();
      location.x = width / 2;
   }
   
   public void eat() {
      size++;
   }
   
   public void draw() {
      noStroke();
      fill(colors[colorIndex].x, colors[colorIndex].y, colors[colorIndex].z);
      rect(location.x, location.y, size, size);
   }
}
//void keyPressed() {
//   switch(key) {
//      case 32: { // SPACE
//         if (gameScreen == 0) {
//            gameScreen = 1;
//            initGame();
//         } else if (gameScreen == 1) {
//            p.eat(new Blob(1, 1, new PVector(), new PVector()));
//         }
//         break;
//      }
//      case 119: { // W
//         if (gameScreen == 1)
//            input.add(key);
//         break;
//      }      
//      case 115: { // S
//         if (gameScreen == 1)
//            input.add(key);
//         break;
//      }
//      case 97: { // A
//         if (gameScreen == 1)
//            input.add(key);
//         break;
//      }
//      case 100: { // D
//         if (gameScreen == 1)
//            input.add(key);
//         break;
//      }
//      case CODED: { // UP AND DOWN ARROWS
//         break;
//      }
      
//      default: {
//         print("KEY NOT RECOGNIZED");
//      }
//   } 
//}

//void keyReleased() {
//   switch(key) {
//      case 119: { // W
//         if (gameScreen == 1)
//            input.remove(key);
//         break;
//      }      
//      case 115: { // S
//         if (gameScreen == 1)
//            input.remove(key);
//         break;
//      }
//      case 97: { // A
//         if (gameScreen == 1)
//            input.remove(key);
//         break;
//      }
//      case 100: { // D
//         if (gameScreen == 1)
//            input.remove(key);
//         break;
//      }
//      case CODED: { // UP AND DOWN ARROWS
//         break;
//      }
      
//      default: {
         
//      }
//   }
//}
   public void settings() {  size(600, 400); }
   static public void main(String[] passedArgs) {
      String[] appletArgs = new String[] { "JellyBlobs" };
      if (passedArgs != null) {
        PApplet.main(concat(appletArgs, passedArgs));
      } else {
        PApplet.main(appletArgs);
      }
   }
}
