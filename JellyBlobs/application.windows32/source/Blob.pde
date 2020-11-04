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
   
   void move() {
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
   
   void draw() {
      noStroke();
      fill(138, 43, 226); //poiple
      rect(location.x, location.y, size, size);
   }
   
   void setLocation(PVector location) {
      this.location = location;
   }
   
   void setDirection(PVector direction) {
      this.direction = direction;
   }
   
   void getEaten() {
      isEaten = true;
      movementEnabled = false;
   }
 
   boolean isEaten() { return isEaten; }
   PVector getLocation() { return location; }
   int getSize() { return size; }
   PVector getDirection() { return direction; }
   boolean movementEnabled() { return movementEnabled; }
}
