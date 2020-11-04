//void processInput() {
//   String input = inputQueue.getFirst();
//   if (input == null) {
//      return;
//   }
   
//   switch(input) {
//      case "UP": {
//         if (s.getDirection().equals("UP") || s.getDirection().equals("DOWN")) {
//            processInput();
//            return;
//         }
//      }
//      case "LEFT": {
//         if (s.getDirection().equals("LEFT") || s.getDirection().equals("RIGHT")) {
//            processInput();
//            return;
//         }
//      }
//      case "DOWN": {
//         if (s.getDirection().equals("DOWN") || s.getDirection().equals("UP")) {
//            processInput();
//            return;
//         }
//      }
//      case "RIGHT": {
//         if (s.getDirection().equals("RIGHT") || s.getDirection().equals("LEFT")) {
//            processInput();
//            return;
//         }
//      }
//      default: {
//         print("YOU FUCKED UP PROCESSINPUT");
//      }
//   }
   
//   s.changeDirection(input);
//}

//void keyPressed() {
//   print(inputQueue + "\n");
//   switch(key) {
//      case 119: {
//         inputQueue.add("UP");
//         break;
//      }
//      case 97: {
//         inputQueue.add("LEFT");
//         break;
//      }
      
//      case 115: {
//         inputQueue.add("DOWN");
//         break;
//      }
      
//      case 100: {
//         if (gameScreen == 0) {
//            gameScreen = 1;
//            background(15);
//            spawnFood();
//         } else if (gameScreen == 1) {
//            inputQueue.add("RIGHT");
//         }
//         break;
//      }
      
//      default: {
//         print("YOU FUCKED UP KEYPRESSED");
//      }
//   } 
//}


















//void processInput() {
//   String input = inputQueue.getFirst();
//   if (input == null) {
//      return;
//   }
//   s.changeDirection(input);
//}

//void keyPressed() {
//   print(inputQueue + "\n");
//   switch(key) {
//      case 119: {
//         if ((inputQueue.peek() != null && (!inputQueue.peek().equals("UP") || !inputQueue.peek().equals("DOWN"))) ||
//            !s.getDirection().equals("DOWN"))
//            inputQueue.add("UP");
//         break;
//      }
//      case 97: {
//         if ((inputQueue.peek() != null && (!inputQueue.peek().equals("LEFT") || !inputQueue.peek().equals("RIGHT"))) ||
//            !s.getDirection().equals("RIGHT"))
//            inputQueue.add("LEFT");
//         break;
//      }
      
//      case 115: {
//         if ((inputQueue.peek() != null && (!inputQueue.peek().equals("DOWN") || !inputQueue.peek().equals("UP"))) ||
//            !s.getDirection().equals("UP"))
//            inputQueue.add("DOWN");
//         break;
//      }
      
//      case 100: {
//         if (gameScreen == 0) {
//            gameScreen = 1;
//            background(15);
//            spawnFood();
//         } else if (gameScreen == 1) {
//            if ((inputQueue.peek() != null && (!inputQueue.peek().equals("RIGHT") || !inputQueue.peek().equals("LEFT"))) ||
//               !s.getDirection().equals("LEFT"))
//               inputQueue.add("RIGHT");
//         }
//         break;
//      }
      
//      default: {
//         print("YOU FUCKED UP KEYPRESSED");
//      }
//   } 
//}
