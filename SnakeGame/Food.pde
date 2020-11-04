public class Food {
   private int value;
   private PVector loc;
   
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
   
   void draw() {
      fill(245, 245, 245);
      rect(food.getLocation().x * cellWidth + 2, food.getLocation().y * cellHeight + 2, cellWidth - 2, cellHeight - 2);
   }
}
