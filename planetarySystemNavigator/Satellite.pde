public class Satellite extends CelestialBody implements Translatable {
  private float translationDelta;

  public Satellite(float radius, PVector position, color bodyColor, PVector rotationDelta, float translationDelta) {
    super(radius, position, rotationDelta, bodyColor);
    this.translationDelta = translationDelta;
  }
  
  public void translate(PVector origin) {
    translate(origin, this.translationDelta);
  }
  
  public void translate(PVector origin, float translationDelta) {
    PVector pos = PVector.sub(super.position, origin);
    
    pos = new PVector( 
      pos.x * cos(translationDelta) - pos.z * sin(translationDelta), 
      pos.y, 
      pos.x * sin(translationDelta) + pos.z * cos(translationDelta)
    );
    
    super.position = PVector.add(pos, origin);
  }
  
  public void draw() {
    super.draw();
  }
}
