public class Star extends CelestialBody {
  private Planet[] planets;
  
  public Star(float radius, PVector position, color bodyColor, PVector rotationDelta, Planet[] planets) {
    super(radius, position, rotationDelta, bodyColor);
    this.planets = planets;
  }

  public void draw() {
    pointLight(255, 255, 255, super.position.x, super.position.y, super.position.z);
    ambientLight(255, 255, 255, super.position.x, super.position.y, super.position.z);
    super.draw();
    
    for (Planet planet : planets) {
      planet.translate(super.position);
      planet.rotate();
      planet.draw();
    }
  }
}
