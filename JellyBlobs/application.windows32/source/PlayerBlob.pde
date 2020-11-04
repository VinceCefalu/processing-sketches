class PlayerBlob extends Blob {
   float friction;
   
   public PlayerBlob() {
      super();
      location.x = width / 2;
   }
   
   void eat() {
      size++;
   }
   
   void draw() {
      noStroke();
      fill(colors[colorIndex].x, colors[colorIndex].y, colors[colorIndex].z);
      rect(location.x, location.y, size, size);
   }
}
