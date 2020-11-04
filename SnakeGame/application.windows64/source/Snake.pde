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
   
   void move() {
      tail.update(location, currentLength);
      
      if (currentLength == 0) {
         fill(15);
         rect(location.x * cellWidth + 2, location.y * cellHeight + 2, cellWidth - 2, cellHeight - 2);
      }
      
      location.x += direction.x;
      location.y += direction.y;
      hasMoved = true;
   }
   
   void eat() {
      currentLength++;
   }
   
   boolean isFull() {
      return (currentLength == winLength);
   }
   
   void changeDirection(String d) {
      switch(d) {
      case "UP": { direction.x = 0; direction.y = -1; break; } 
      case "LEFT": { direction.x = -1; direction.y = 0; break; }
      case "DOWN": { direction.x = 0; direction.y = 1; break; }
      case "RIGHT": { direction.x = 1; direction.y = 0; break; }
      default: print("YOU FUCKED UP");
      }
      hasMoved = false;
   }
   
   String getDirection() {
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
   
   void draw() {
      fill(colors[colorIndex].x, colors[colorIndex].y, colors[colorIndex].z);
      rect(location.x * cellWidth + 2, location.y * cellHeight + 2, cellWidth - 2, cellHeight - 2);
      //tail.draw();
   }
   
   PVector getLocation() { return location; } 
   int getLength() { return currentLength; }
   int getWinLength() { return winLength; }
   PVector[] getTail() { return tail.snakeTail; }
   boolean hasMoved() { return hasMoved; }
}
