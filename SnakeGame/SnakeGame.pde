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

void setup() {
   frameRate(60);
   size(600, 480);
   
   // cells are the same size regardless of screen size, which
   // is mainly so I could test performance for fun in full 1080p
   // The amount of food you would need to collect is over 5000
   cellpx = 20;
   numCellsX = width / cellpx;
   numCellsY = height / cellpx;
   
   cellWidth = width / numCellsX;  
   cellHeight = height / numCellsY;
   
   curMillis = millis();
   tickLength = 130; // the speed of the game. Lower = faster
   
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

void initScreen() {
   background(backgroundColor);
   
   textAlign(CENTER);
   fill(255);
   text("Controls:\nW = UP\nS = DOWN\nA = LEFT\nD = RIGHT\n\nPress SPACE to begin!", width/2, height/2 - 100);
   text("Choose a color with A or D!", width / 2, height / 2 + 40);
   
   fill(colors[colorIndex].x, colors[colorIndex].y, colors[colorIndex].z);
   rect(startLocation.x * cellWidth + 2, startLocation.y * cellHeight + 2, cellWidth - 2, cellHeight - 2);
}

void gameScreen() {
   
   // prevent another input being processed before the snake has done the last one
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

void gameOverScreen() {
   background(backgroundColor);
   fill(255);
   textAlign(CENTER);
   text("Game Over!\nYou ate " + (s.getLength()) + " / " + s.getWinLength() + " pieces of food!\n" + 
        "Press SPACE to restart!", width/2, height/2 - 30);
}

void winScreen() {
   textSize(32);
   fill(255);
   textAlign(CENTER);
   text("You win!", width / 2, height / 2 - 30);
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
      gameOverScreen();
   } else if (gameScreen == 3) {
      winScreen();
   }
}


///////////////
//   INPUT   //
///////////////

void processInput() {
   String input = inputQueue.getFirst();
   if (input == null) {
      return;
   }
   
   // Basically here to prevent any illegal actions by first checking if the 
   // snake is heading in the same, or an opposite direction to the one most
   // recently input. For example: up->down, left->left
   // I suppose it doesn't really save much time to cancel a changeDirection call if
   // the inputs are the same, but I'll leave it in there anyway
   switch(input) {
      case "UP": {
         if (s.getDirection().equals("UP") || s.getDirection().equals("DOWN")) {
            return;
         }
         break;
      }
      case "LEFT": {
         if (s.getDirection().equals("LEFT") || s.getDirection().equals("RIGHT")) {
            return;
         }
         break;
      }
      case "DOWN": {
         if (s.getDirection().equals("DOWN") || s.getDirection().equals("UP")) {
            return;
         }
         break;
      }
      case "RIGHT": {
         if (s.getDirection().equals("RIGHT") || s.getDirection().equals("LEFT")) {
            return;
         }
         break;
      }
      default: {
         print("YOU MESSED UP PROCESSINPUT");
      }
   }
   
   s.changeDirection(input);
}

void keyPressed() {
   switch(key) {
      case 87: // W
      case 119: { // w
         inputQueue.add("UP");
         break;
      }
      
      case 65: // A
      case 97: { // a
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
      
      case 83: // S
      case 115: { // s
         inputQueue.add("DOWN");
         break;
      }
      
      case 68: // D
      case 100: { // d
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
         print("YOU MESSED UP KEYPRESSED");
      }
   } 
}

///////////////
//   OTHER   //
///////////////

void initGame() {
   s = new Snake(startLocation, (numCellsX * numCellsY) - 1);
   inputQueue = new InputQueue();
   background(backgroundColor);
   spawnFood();
}

void spawnFood() {
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

boolean isIntersecting(PVector location1, PVector location2) {
   return (location1.x == location2.x && location1.y == location2.y);
}

boolean isOffscreen(PVector location) {
   return (location.x > numCellsX - 1 || location.x < 0 || location.y > numCellsY - 1 || location.y < 0);
}
