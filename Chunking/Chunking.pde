/**
* This is a small one where I finally realized one way you could
* break a big world into small chunks (like in Terraria) to actually
* be performant and still be able to simulate things happening when you
* aren't drawing them. Then the chunks can be set to active as you need
* them (in this case, when the mouse is over them) showing what is going
* on underneath. In reality you wouldn't see all the chunks at once and
* instead they would only be active if they were on screen
*
* Anyway it was fun for me to realize this, code it up, and see it work very
* well. Without it, rendering all the pixels here would result in 1-2 FPS
* (which can be tried with numChunks = 1)
**/

Chunk[][] chunks;
int[][] pix;
int numChunks = 10;

void setup() {
   frameRate(60);
   size(800, 600);
   textSize(24);
   
   chunks = new Chunk[numChunks][numChunks];
   for (int i = 0; i < chunks.length; i++) {
      for (int j = 0; j < chunks[i].length; j++) {
         chunks[i][j] = new Chunk(width / numChunks, height / numChunks, i * width / numChunks, j * height / numChunks);
      }
   }
   
   chunks[0][0].isActive = true;
}

void draw() {
   //background(150);
   for (int i = 0; i < chunks.length; i++) {
      for (int j = 0; j < chunks[i].length; j++) {
         if (chunks[i][j].pointInsideChunk(mouseX, mouseY)) {
            chunks[i][j].isActive = true;
         } else {
            chunks[i][j].isActive = false;
         }
         chunks[i][j].doSomething();
         chunks[i][j].draw();
      }
   }
   //fill(255, 0, 0);
   //text("Framerate: " + nfc(frameRate, 2), 10, 24);
}
