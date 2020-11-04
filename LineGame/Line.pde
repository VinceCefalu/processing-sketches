public class Line {
   private PVector start, end;
   private int rotSpeed; //In deg/sec
   private int i = 1, r = 50, s = 0;
   
   public Line() {
      start = new PVector(width/2, height/2);
      rotSpeed = 32;
   }
   
   public PVector getStartPoint() {
      return start;
   }
   
   public PVector getEndPoint() {
      return end;
   }
   
   public int getRadius() {
      return r;
   }
   public int getSpeed() {
      return s;
   }
   
   public void draw() {
      i++;
      if (i > (rotSpeed - s) * 2) {
         i -= (rotSpeed - s) * 2;
      }
      end = new PVector(start.x + r * cos(PI / (rotSpeed - s) * i), start.y + r * sin(PI / (rotSpeed - s) * i));
      line(start.x, start.y, end.x, end.y);
   }
   
   public void swap() {
      i += (rotSpeed - s);
      start.x = start.x - r * cos(PI / (rotSpeed - s) * i);
      start.y = start.y - r * sin(PI / (rotSpeed - s) * i);
   }
   
   public boolean offScreen() {
      if (end.x > width || end.x < 0 || end.y > height || end.y < 0) {
         return true;
      }
      return false;
   }
   
   public void speedUp() {
      s += 2;
   }
}
