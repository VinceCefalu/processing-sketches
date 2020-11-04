/**
* The snake's tail acts a little differently, which is why I separated it out
* The important thing is that every update only the segment right after the head 
* is drawn and the last segment of the tail is erased
**/

class SnakeTail {
   private PVector[] snakeTail;
   private int head, tail;
   
   public SnakeTail(int winLength) {
      snakeTail = new PVector[winLength];
      head = 0; tail = 0;
   }
   
   void add(PVector location) {
      if (head == snakeTail.length - 1)
         head = 0;
      else
         head++;
         
      snakeTail[head] = new PVector(location.x, location.y);
   }
   
   void remove() {
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
   
   void update(PVector location, int currentLength) {
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
   
   void draw() {
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
