String title = "Planetary system";
PImage background;
PlanetarySystemController controller;

boolean isEnterPressed = false;
boolean isWPressed = false;
boolean isSPressed = false;
boolean isAPressed = false;
boolean isDPressed = false;
boolean isUpPressed = false;
boolean isDownPressed = false;
boolean isLeftPressed = false;
boolean isRightPressed = false;

PShape ship;
PFont defaultFont;


public void settings(){
  size(1000, 1000, P3D);
  controller = new PlanetarySystemController();
}

public void setup() {
  surface.setTitle(title);
  background = loadImage("stars.jpg");
  ship = loadShape("model.obj");
  ship.rotateX(-PI/32);
  ship.rotate(PI, 0, 0, 1);
  ship.rotateY(PI);
  ship.scale(getRelativeToCanvasWidth(0.02));
  defaultFont = createFont("Arial", 15);
}

public void draw() {
  noCursor();
  background(background);
  controller.run();
}

public float getRelativeToCanvasWidth(float rel) {
    return width * rel; 
}

public float getRelativeToCanvasHeight(float rel) {
    return height * rel; 
}

void keyPressed() {
  if (key == 'w' || key == 'W') {
    isWPressed = true;    
  }
  
  if (key == 'a' || key == 'A') {
    isAPressed = true;    
  }
  
  if (key == 's' || key == 'S') {
    isSPressed = true;    
  }
  
  if (key == 'd' || key == 'D') {
    isDPressed = true;    
  }
  
  if (key == ENTER) {
    isEnterPressed = true;
  }
  
  if (key == CODED) {
    if (keyCode == UP) {
      isUpPressed = true; 
    }
    
    if (keyCode == DOWN) {
      isDownPressed = true;
    }
    
    if (keyCode == LEFT) {
      isLeftPressed = true; 
    }
    
    if (keyCode == RIGHT) {
      isRightPressed = true;
    }
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    isWPressed = false;    
  }
  
  if (key == 'a' || key == 'A') {
    isAPressed = false;    
  }
  
  if (key == 's' || key == 'S') {
    isSPressed = false;    
  }
  
  if (key == 'd' || key == 'D') {
    isDPressed = false;    
  }
  
  if (key == ENTER || key == RETURN) {
    isEnterPressed = false;
  }
  
  if (key == CODED) {
    if (keyCode == UP) {
      isUpPressed = false; 
    }

    if (keyCode == DOWN) {
      isDownPressed = false;
    }
    
    if (keyCode == LEFT) {
      isLeftPressed = false; 
    }
    
    if (keyCode == RIGHT) {
      isRightPressed = false;
    }
  }
}
