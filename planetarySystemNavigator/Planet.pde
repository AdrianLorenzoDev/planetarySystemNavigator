public class Planet extends CelestialBody implements Translatable {
  private float translationDelta;
  private Satellite[] satellites;
  
  public Planet(float radius, PVector position, color bodyColor, PVector rotationDelta, float translationDelta, Satellite[] satellites) {
    super(radius, position, rotationDelta, bodyColor);
    this.translationDelta = translationDelta;
    this.satellites = satellites;
  }
  
  public void translate(PVector origin) {
    PVector pos = PVector.sub(super.position, origin);
    
    pos = new PVector( 
      pos.x * cos(translationDelta) - pos.z * sin(translationDelta), 
      pos.y, 
      pos.x * sin(translationDelta) + pos.z * cos(translationDelta)
    );
    
    super.position = pos.add(origin);
    
    for (Satellite satellite : satellites) {
      satellite.translate(origin, this.translationDelta);
    }
  }
  
  public void draw() {
    super.draw();
    for (Satellite satellite : satellites) {
      satellite.translate(super.position);
      satellite.rotate();
      satellite.draw();
    }
  }
}
