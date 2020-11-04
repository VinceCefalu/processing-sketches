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
   
   void eat() {
      atePlayer = true;
   }
   
   void draw() {
      noStroke();
      fill(138, 43, 226); //poiple
      rect(location.x, location.y, size, size);
   }
   
   boolean atePlayer() { return atePlayer; }
}
