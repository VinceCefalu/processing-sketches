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

public class SnakeGame extends PApplet {

int gameScreen;

Snake s;
int curMillis, tickLength;

int numCellsX, numCellsY;
int cellWidth, cellHeight;
int cellpx;
int backgroundColor;

Food food;
String lastMove;
InputQueue inputQueue;
int colorIndex;
PVector[] colors;
PVector startLocation;

public void setup() {
   frameRate(60);
   
   cellpx = 20;
   numCellsX = width / cellpx;
   numCellsY = height / cellpx;
   
   cellWidth = width / numCellsX;  
   cellHeight = height / numCellsY;
   
   curMillis = millis();
   tickLength = 125;
   
   startLocation = new PVector(numCellsX / 2 - 1, numCellsY / 2);
   
   initGame();
   gameScreen = 0;
   
   colors = new PVector[4];
   colors[0] = new PVector(50, 255, 50);
   colors[1] = new PVector(135, 206, 250);
   colors[2] = new PVector(240, 120, 20);
   colors[3] = new PVector(240, 60, 60);
   
   colorIndex = 0;
   backgroundColor = 15;
}


//////////////////////
//   GAME SCREENS   //
//////////////////////

public void initScreen() {
   background(backgroundColor);
   
   textAlign(CENTER);
   fill(255);
   text("Controls:\nW = UP\nS = DOWN\nA = LEFT\nD = RIGHT\n\nPress SPACE to begin!", width/2, height/2 - 100);
   text("Choose a color with A or D!", width / 2, height / 2 + 40);
   
   fill(colors[colorIndex].x, colors[colorIndex].y, colors[colorIndex].z);
   rect(startLocation.x * cellWidth + 2, startLocation.y * cellHeight + 2, cellWidth - 2, cellHeight - 2);
}

public void gameScreen() {
   
   if (s.hasMoved())
      processInput();
      
   if (curMillis + tickLength <= millis()) {
      curMillis = millis();
      s.move();
   }
   
   if (isIntersecting(s.getLocation(), food.getLocation())) {
      s.eat();
      if (s.isFull())
         gameScreen = 3;
      else
         spawnFood();
   }
   
   for (PVector segment : s.getTail()) {
      if (segment != null) {
         if (isIntersecting(s.getLocation(), segment)) {
            gameScreen = 2;
         }
      }
   }
   
   if (isOffscreen(s.getLocation())) {
      gameScreen = 2;
   }
   
   s.draw();
}

public void gameOverScreen() {
   background(backgroundColor);
   fill(255);
   textAlign(CENTER);
   text("Game Over!\nYou ate " + (s.getLength()) + " / " + s.getWinLength() + " pieces of food!\n" + 
        "Press SPACE to restart!", width/2, height/2 - 30);
}

public void winScreen() {
   textSize(32);
   fill(255);
   textAlign(CENTER);
   text("You win!", width / 2, height / 2 - 30);
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
      gameOverScreen();
   } else if (gameScreen == 3) {
      winScreen();
   }
}


///////////////
//   INPUT   //
///////////////

public void processInput() {
   String input = inputQueue.getFirst();
   if (input == null) {
      return;
   }
   
   switch(input) {
      case "UP": {
         if (s.getDirection().equals("UP") || s.getDirection().equals("DOWN")) {
            //processInput();
            return;
         }
         break;
      }
      case "LEFT": {
         if (s.getDirection().equals("LEFT") || s.getDirection().equals("RIGHT")) {
            //processInput();
            return;
         }
         break;
      }
      case "DOWN": {
         if (s.getDirection().equals("DOWN") || s.getDirection().equals("UP")) {
            //processInput();
            return;
         }
         break;
      }
      case "RIGHT": {
         if (s.getDirection().equals("RIGHT") || s.getDirection().equals("LEFT")) {
            //processInput();
            return;
         }
         break;
      }
      default: {
         print("YOU FUCKED UP PROCESSINPUT");
      }
   }
   
   s.changeDirection(input);
}

public void keyPressed() {
   switch(key) {
      case 119: { // W
         inputQueue.add("UP");
         break;
      }
      case 97: { // A
         if (gameScreen == 0) {
            colorIndex--;
            if (colorIndex < 0) {
               colorIndex = colors.length - 1;
            }
         } else if (gameScreen == 1) {
            inputQueue.add("LEFT");
         }
         break;
      }
      
      case 115: { // S
         inputQueue.add("DOWN");
         break;
      }
      
      case 100: { // D
         if (gameScreen == 0) {
            colorIndex++;
            if (colorIndex >= colors.length) {
               colorIndex = 0;
            }
         } else if (gameScreen == 1) {
            inputQueue.add("RIGHT");
         }
         break;
      }
      case 32: { // SPACE
         if (gameScreen == 0) {
            gameScreen = 1;
            initGame();
         } else if (gameScreen == 2) {
            gameScreen = 0;
         }
         break;
      }
      
      default: {
         print("YOU FUCKED UP KEYPRESSED");
      }
   } 
}

///////////////
//   OTHER   //
///////////////

public void initGame() {
   s = new Snake(startLocation, (numCellsX * numCellsY) - 1);
   inputQueue = new InputQueue();
   background(backgroundColor);
   spawnFood();
}

public void spawnFood() {
   int x = 0, y = 0;
   boolean isValidLocation = false;
   
   while (!isValidLocation) {
      x = (int)random(0, numCellsX);
      y = (int)random(0, numCellsY);
      isValidLocation = true;
      for (PVector loc : s.getTail()) {
         if (loc != null && isIntersecting(loc, new PVector(x, y))) {
            isValidLocation = false;
         }
      }
   }
   food = new Food(1, new PVector(x, y));
   food.draw();
}

public boolean isIntersecting(PVector location1, PVector location2) {
   return (location1.x == location2.x && location1.y == location2.y);
}

public boolean isOffscreen(PVector location) {
   return (location.x > numCellsX - 1 || location.x < 0 || location.y > numCellsY - 1 || location.y < 0);
}
public class Food {
   private int value;
   private PVector loc;
   private boolean isSpecial;
   
   public Food(int value, PVector loc) {
      this.value = value;
      this.loc = loc;
      
   }
   
   public PVector getLocation() {
      return loc;
   }
   
   public int getValue() {
      return value;
   }
   
   public void draw() {
      fill(245, 245, 245);
      rect(food.getLocation().x * cellWidth + 2, food.getLocation().y * cellHeight + 2, cellWidth - 2, cellHeight - 2);
   }
}
class InputQueue {
   String[] items;
   int head, tail;
   
   public InputQueue() {
      items = new String[5];
      head = 0;
      tail = 0;
   }
   
   public void add(String input) {
      if (tail == items.length - 1)
         tail = 0;
      else
         tail++;
      
      if (items[tail] == null) {
         items[tail] = input;
      } else {
         tail--;
         return;
      }
   }
   
   private void remove() {
      items[head] = null;
      if (head == items.length - 1)
         head = 0;
      else
         head++;
   }
   
   public String peek() {
      return items[head];
   }
   
   public String getFirst() {
      String s = items[head];
      remove();
      return s;
   }
   
   public String toString() {
      String out = "";
      for (String s : items) {
         out += s + ", ";
      }
      return out;
   }
}
class Snake {
   SnakeTail tail;
   PVector location;
   PVector direction;
   int currentLength, winLength;
   boolean hasMoved;
   
   
   Snake(PVector startPosition, int winLength) {
      location = new PVector(startPosition.x, startPosition.y);
      direction = new PVector(1, 0);
      currentLength = 0;
      this.winLength = winLength;
      tail = new SnakeTail(winLength);
      hasMoved = false;
   }
   
   public void move() {
      tail.update(location, currentLength);
      
      if (currentLength == 0) {
         fill(15);
         rect(location.x * cellWidth + 2, location.y * cellHeight + 2, cellWidth - 2, cellHeight - 2);
      }
      
      location.x += direction.x;
      location.y += direction.y;
      hasMoved = true;
   }
   
   public void eat() {
      currentLength++;
   }
   
   public boolean isFull() {
      return (currentLength == winLength);
   }
   
   public void changeDirection(String d) {
      switch(d) {
      case "UP": { direction.x = 0; direction.y = -1; break; } 
      case "LEFT": { direction.x = -1; direction.y = 0; break; }
      case "DOWN": { direction.x = 0; direction.y = 1; break; }
      case "RIGHT": { direction.x = 1; direction.y = 0; break; }
      default: print("YOU FUCKED UP");
      }
      hasMoved = false;
   }
   
   public String getDirection() {
      if (direction.x == 0) {
         if (direction.y == -1) {
            return "UP";
         } else {
            return "DOWN";
         }
      } else if (direction.y == 0) {
         if (direction.x == -1) {
            return "LEFT";
         } else {
            return "RIGHT";
         }
      }
      
      return "YOU FUCKED UP";
   }
   
   public void draw() {
      fill(colors[colorIndex].x, colors[colorIndex].y, colors[colorIndex].z);
      rect(location.x * cellWidth + 2, location.y * cellHeight + 2, cellWidth - 2, cellHeight - 2);
      //tail.draw();
   }
   
   public PVector getLocation() { return location; } 
   public int getLength() { return currentLength; }
   public int getWinLength() { return winLength; }
   public PVector[] getTail() { return tail.snakeTail; }
   public boolean hasMoved() { return hasMoved; }
}
class SnakeTail {
   private PVector[] snakeTail;
   private int head, tail;
   
   public SnakeTail(int winLength) {
      snakeTail = new PVector[winLength];
      head = 0; tail = 0;
   }
   
   public void add(PVector location) {
      if (head == snakeTail.length - 1)
         head = 0;
      else
         head++;
         
      snakeTail[head] = new PVector(location.x, location.y);
   }
   
   public void remove() {
      if (snakeTail[tail] != null) {
         fill(backgroundColor);
         rect(snakeTail[tail].x * cellWidth, snakeTail[tail].y * cellHeight, cellWidth, cellHeight);
      }
      snakeTail[tail] = null;
      if (tail == snakeTail.length - 1)
         tail = 0;
      else
         tail++;
   }
   
   public void update(PVector location, int currentLength) {
      if (currentLength == 0) {
         return;
      } else if (tail > head) {
         if (head + snakeTail.length - tail + 1 == currentLength) {
            add(location);
            remove();
         } else {
            add(location);
         }
      } else if (head >= tail) {
         if (head - tail + 1 == currentLength) {
            add(location);
            remove();
         } else {
            add(location);
         }
      } else {
         add(location);
      }
   }
   
   public void draw() {
      fill(colors[colorIndex].x, colors[colorIndex].y, colors[colorIndex].z);
      int i = head;
      while (snakeTail[i] != null) {
         rect(snakeTail[i].x * cellWidth + 2, snakeTail[i].y * cellHeight + 2, cellWidth - 2, cellHeight - 2);
         if (i == 0)
            i = snakeTail.length - 1;
         else
            i--;
      }
   }
}
//void processInput() {
//   String input = inputQueue.getFirst();
//   if (input == null) {
//      return;
//   }
   
//   switch(input) {
//      case "UP": {
//         if (s.getDirection().equals("UP") || s.getDirection().equals("DOWN")) {
//            processInput();
//            return;
//         }
//      }
//      case "LEFT": {
//         if (s.getDirection().equals("LEFT") || s.getDirection().equals("RIGHT")) {
//            processInput();
//            return;
//         }
//      }
//      case "DOWN": {
//         if (s.getDirection().equals("DOWN") || s.getDirection().equals("UP")) {
//            processInput();
//            return;
//         }
//      }
//      case "RIGHT": {
//         if (s.getDirection().equals("RIGHT") || s.getDirection().equals("LEFT")) {
//            processInput();
//            return;
//         }
//      }
//      default: {
//         print("YOU FUCKED UP PROCESSINPUT");
//      }
//   }
   
//   s.changeDirection(input);
//}

//void keyPressed() {
//   print(inputQueue + "\n");
//   switch(key) {
//      case 119: {
//         inputQueue.add("UP");
//         break;
//      }
//      case 97: {
//         inputQueue.add("LEFT");
//         break;
//      }
      
//      case 115: {
//         inputQueue.add("DOWN");
//         break;
//      }
      
//      case 100: {
//         if (gameScreen == 0) {
//            gameScreen = 1;
//            background(15);
//            spawnFood();
//         } else if (gameScreen == 1) {
//            inputQueue.add("RIGHT");
//         }
//         break;
//      }
      
//      default: {
//         print("YOU FUCKED UP KEYPRESSED");
//      }
//   } 
//}


















//void processInput() {
//   String input = inputQueue.getFirst();
//   if (input == null) {
//      return;
//   }
//   s.changeDirection(input);
//}

//void keyPressed() {
//   print(inputQueue + "\n");
//   switch(key) {
//      case 119: {
//         if ((inputQueue.peek() != null && (!inputQueue.peek().equals("UP") || !inputQueue.peek().equals("DOWN"))) ||
//            !s.getDirection().equals("DOWN"))
//            inputQueue.add("UP");
//         break;
//      }
//      case 97: {
//         if ((inputQueue.peek() != null && (!inputQueue.peek().equals("LEFT") || !inputQueue.peek().equals("RIGHT"))) ||
//            !s.getDirection().equals("RIGHT"))
//            inputQueue.add("LEFT");
//         break;
//      }
      
//      case 115: {
//         if ((inputQueue.peek() != null && (!inputQueue.peek().equals("DOWN") || !inputQueue.peek().equals("UP"))) ||
//            !s.getDirection().equals("UP"))
//            inputQueue.add("DOWN");
//         break;
//      }
      
//      case 100: {
//         if (gameScreen == 0) {
//            gameScreen = 1;
//            background(15);
//            spawnFood();
//         } else if (gameScreen == 1) {
//            if ((inputQueue.peek() != null && (!inputQueue.peek().equals("RIGHT") || !inputQueue.peek().equals("LEFT"))) ||
//               !s.getDirection().equals("LEFT"))
//               inputQueue.add("RIGHT");
//         }
//         break;
//      }
      
//      default: {
//         print("YOU FUCKED UP KEYPRESSED");
//      }
//   } 
//}
   public void settings() {  size(600, 400); }
   static public void main(String[] passedArgs) {
      String[] appletArgs = new String[] { "SnakeGame" };
      if (passedArgs != null) {
        PApplet.main(concat(appletArgs, passedArgs));
      } else {
        PApplet.main(appletArgs);
      }
   }
}
