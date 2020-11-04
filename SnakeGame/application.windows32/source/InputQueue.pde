class InputQueue {
   String[] items;
   int head, tail;
   
   public InputQueue() {
      items = new String[5];
      head = 0;
      tail = 0;
   }
   
   void add(String input) {
      if (tail == items.length - 1)
         tail = 0;
      else
         tail++;
      
      if (items[tail] == null) {
         items[tail] = input;
      } else {
         tail--;
         return;
      }
   }
   
   private void remove() {
      items[head] = null;
      if (head == items.length - 1)
         head = 0;
      else
         head++;
   }
   
   String peek() {
      return items[head];
   }
   
   String getFirst() {
      String s = items[head];
      remove();
      return s;
   }
   
   String toString() {
      String out = "";
      for (String s : items) {
         out += s + ", ";
      }
      return out;
   }
}
