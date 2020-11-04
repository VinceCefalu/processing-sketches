class Chunk {
   int[][] pix;
   boolean isActive;
   int xPos, yPos;
   int w, h;
   
   public Chunk(final int WIDTH, final int HEIGHT, int xPos, int yPos) {
      pix = new int[WIDTH][HEIGHT];
      w = WIDTH;
      h = HEIGHT;
      isActive = false;
      this.xPos = xPos;
      this.yPos = yPos;
   }
   
   void draw() {
      if (!isActive) {
         return;
      }
      
      for (int i = 0; i < pix.length; i++) {
         for (int j = 0; j < pix[i].length; j++) {
            if (pix[i][j] == 0) {
               stroke(0);
            } else {
               stroke(255);
            }
            
            point(i + xPos, j + yPos);
         }
      }
   }
   
   // Randomizes all pixels in the chunk to either 1 or 0
   // which will be drawn as white or black resp.
   void doSomething() {
      for (int i = 0; i < pix.length; i++) {
         for (int j = 0; j < pix[i].length; j++) {
            pix[i][j] = Math.round(random(1));
         }
      }
   }
   
   boolean pointInsideChunk(int x, int y) {
      if (x > xPos && x < xPos + w &&
         y > yPos && y < yPos + h) {
            return true;
         }
         return false;
   }
}
