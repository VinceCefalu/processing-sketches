/**
* Input buffer is meant to help in holding multiple key presses
* which allows for diagonal movement and avoids the repeated key pressing
* issue that is present in windows which cancels the player's movement
**/
class InputBuffer {
   int[] buffer = { -1, -1 };
   int last;
   
   public InputBuffer() {
      last = 0;
   }
   
   void add(int inputKey) {
      if (buffer[0] != inputKey && buffer[1] != inputKey) {
         last = (last == 0) ? 1 : 0;
         buffer[last] = inputKey;
      }
   }
   
   void remove(int inputKey) {
      if (buffer[0] == inputKey) {
         buffer[0] = -1;
         last = 1;
      }
      if (buffer[1] == inputKey) {
         buffer[1] = -1;
         last = 0;
      }
   }
   
   boolean contains(int inputKey) {
      return buffer[0] == inputKey || buffer[1] == inputKey;
   }
   
   void clear() {
      buffer[0] = -1;
      buffer[1] = -1;
   }
   
   int[] getBuffer() { return buffer; }
}
