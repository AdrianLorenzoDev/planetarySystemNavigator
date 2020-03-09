public class PlanetarySystemController {
   private Star star;
   private PVector eyePosition;
   private PVector eyeDirection;
   private PVector eyeUp;
   private float yaw = 90;
   private float pitch = 0;
   
   private final float rotationDelta = PI / 128;
   private final float translationDelta = PI / 128;
   private final PVector starPosition = new PVector(getRelativeToCanvasWidth(0.5), getRelativeToCanvasHeight(0.5), 0);
   private final float eyeTranslationDelta = 5;
   private final float eyeRotationDelta = 1;
   
   private boolean generalView = false;
   
   public PlanetarySystemController() {
     float starRadius = getRelativeToCanvasWidth(0.1);
     star = new Star(
       starRadius,
       starPosition,
       Colors.starColors[int(random(0, Colors.starColors.length))],
       new PVector(0, rotationDelta / 2),
       getRandomPlanets(starRadius, starPosition)
     );
     
     eyePosition = new PVector(
       starPosition.x, 
       starPosition.y, 
       starPosition.z - 2000
     );
     
     eyeDirection = new PVector(
       0,
       0,
       1
     );
     
     eyeUp = new PVector(
       0,
       1,
       0
     );
   }
   
   public Planet[] getRandomPlanets(float starRadius, PVector starPosition) {
     Planet[] planets = new Planet[int(random(5, 9))];
     float distance = starPosition.x - starRadius - starRadius*4.5;
     
     for (int i = 0; i < planets.length; i++) {
       float planetRadius = random(starRadius*0.35, starRadius*0.55);
       PVector planetPosition = new PVector(distance, starPosition.y, starPosition.z);
       Satellite[] satellites = getRandomSatellites(planetRadius, planetPosition);

       planets[i] = new Planet(
         planetRadius,
         planetPosition,
         Colors.planetColors[int(random(0, Colors.planetColors.length))],
         new PVector(0, random(-rotationDelta, rotationDelta)),
         random(-translationDelta/3, translationDelta/3),
         satellites
       );
       
       int lastIndex = satellites.length-1; 
       if (lastIndex >= 0) {
         distance = satellites[lastIndex].getPosition().x - satellites[lastIndex].getRadius() - starRadius*3.5;
       } else {
         distance -= planetRadius + starRadius*3.5;
       }
     }
     
     return planets;
   }
   
   public Satellite[] getRandomSatellites(float planetRadius, PVector planetPosition) {
     Satellite[] satellites = new Satellite[int(random(0, 3))];
     float distance = planetPosition.x - planetRadius - planetRadius*2;
     
     for (int i = 0; i < satellites.length; i++) {
       float satelliteRadius = random(planetRadius*0.2, planetRadius*0.4);
       satellites[i] = new Satellite(
         satelliteRadius,
         new PVector(distance, starPosition.y, starPosition.z),
         Colors.satelliteColors[int(random(0, Colors.satelliteColors.length))],
         new PVector(0, random(-rotationDelta, rotationDelta)),
         random(-translationDelta*2, translationDelta*2)
       );
       
       distance -= satelliteRadius + planetRadius*2;
     }
       
    return satellites;
   }
   
   public void updateCameraMovement() {
     if (isWPressed) {
       eyePosition.add(PVector.mult(eyeDirection, eyeTranslationDelta));
     }
     
     if (isSPressed) {
       eyePosition.sub(PVector.mult(eyeDirection, eyeTranslationDelta));
     }
     
     if (isAPressed) {
       PVector crossProduct = new PVector();
       PVector.cross(eyeDirection, eyeUp, crossProduct);
       crossProduct.normalize();
       eyePosition.sub(PVector.mult(crossProduct, eyeTranslationDelta));
     }
     
     if (isDPressed) {
       PVector crossProduct = new PVector();
       PVector.cross(eyeDirection, eyeUp, crossProduct);
       crossProduct.normalize();
       eyePosition.add(PVector.mult(crossProduct, eyeTranslationDelta));
     }
    
     if (isUpPressed) {
       pitch -= eyeRotationDelta;
       pitch = pitch % 360;
     }
     
     if (isDownPressed) {
       pitch += eyeRotationDelta;
       pitch = pitch % 360;
     }
     
     if (isLeftPressed) {
       yaw -= eyeRotationDelta;
       yaw = yaw % 360;
     }
     
     if (isRightPressed) {
       yaw += eyeRotationDelta;
       yaw = yaw % 360;
     }
     
     PVector direction = new PVector(
       cos(radians(yaw)) * cos(radians(pitch)),
       sin(radians(pitch)),
       sin(radians(yaw)) * cos(radians(pitch))
     );
     
     direction.normalize();
     eyeDirection = direction;
   }
   
   public void drawShip() {
     translate(0, 0, 700);
     lights();
     shape(ship, getRelativeToCanvasWidth(0.5), getRelativeToCanvasHeight(0.55), getRelativeToCanvasWidth(0.025), getRelativeToCanvasWidth(0.02));
   }
   
   public void setCamera() {
     PVector dir = PVector.add(eyePosition, eyeDirection);
     camera(
       eyePosition.x, eyePosition.y, eyePosition.z,
       dir.x, dir.y, dir.z,
       eyeUp.x, eyeUp.y, eyeUp.z
     );
   }
   
  public void showControls() {
    fill(255);
    textFont(defaultFont);
    text("WASD keys → Move starship", 
      getRelativeToCanvasWidth(0.02), 
      getRelativeToCanvasHeight(0.98));
    text("ARROWS keys → Rotate starship", 
      getRelativeToCanvasWidth(0.02), 
      getRelativeToCanvasHeight(0.96));
    text("ENTER → Toggle starship/general view", 
      getRelativeToCanvasWidth(0.02), 
      getRelativeToCanvasHeight(0.94));
  }

  public void checkGeneralView() {
    if (isEnterPressed) {
      generalView = !generalView;
      delay(200);
    }
  }
  
  
  public void run() {
    checkGeneralView();
    if (generalView) {
      pushMatrix();
      star.rotate();
      star.draw();
      camera(
       getRelativeToCanvasWidth(0), 
       getRelativeToCanvasWidth(-0.3), 
       getRelativeToCanvasWidth(5), 
       starPosition.x, starPosition.y, 
       starPosition.z, 0, 1, 0);
       popMatrix();
       hint(DISABLE_DEPTH_TEST);
      showControls();
      hint(ENABLE_DEPTH_TEST);
    } else {
      updateCameraMovement();
      setCamera();
      pushMatrix();
      star.rotate();
      star.draw();
      popMatrix();
      camera();
      hint(DISABLE_DEPTH_TEST);
      showControls();
      hint(ENABLE_DEPTH_TEST);
      drawShip();
    }
  }
}
