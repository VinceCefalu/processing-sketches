public class Point {
   private int value;
   private PVector loc;
   private boolean isSpecial;
   
   public Point(int value, PVector loc, boolean isSpecial) {
      this.value = value;
      this.loc = loc;
      this.isSpecial = isSpecial;
      
   }
   
   public PVector getLocation() {
      return loc;
   }
   
   public int getValue() {
      return value;
   }
   
   public void draw() {
      if (isSpecial) {
         fill(255, 25, 25);
      } else {
         fill(255, 255, 25);
      }
      ellipse(loc.x, loc.y, 7, 7);
   }
}
