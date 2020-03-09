public class CelestialBody implements Drawable, Rotatable {
  private PVector position;
  private float radius;
  private PVector rotation;
  private PVector rotationDelta;
  private color bodyColor;
 
  public CelestialBody(float radius, PVector position, PVector rotationDelta, color bodyColor) {
    this.radius = radius; 
    this.position = position;
    this.rotation = new PVector();
    this.rotationDelta = rotationDelta;
    this.bodyColor = bodyColor;
  }
  
  public void rotate() {
    rotation = rotation.add(rotationDelta);
  }
  
  public void setPosition(PVector position) {
     this.position = position;
  }
  
  public PVector getPosition() {
    return this.position;
  }
  
  public float getRadius() {
    return this.radius;
  }

  public void setNewPosition(PVector position) {
    this.position = position;
  }

  public void draw() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    rotateY(rotation.y);
    rotateX(rotation.x);
    noStroke();
    fill(bodyColor);
    sphere(radius);
    popMatrix();
  }
}
