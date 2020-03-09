import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import gifAnimation.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class planetarySystem extends PApplet {



// Game title
String title = "Planetary system";
PFont defaultFont;
PImage background;


// Gif recording only
// GifMaker animation;
// int i = 0; 

PlanetarySystemController controller;

public void settings(){
  size(1100, 1000, P3D);
  controller = new PlanetarySystemController();
}

public void setup() {
  surface.setTitle(title);
  defaultFont = createFont("Arial", 15);
  /**
  Gif recording only
  animation = new GifMaker(this, "../images/demo.gif");
  animation.setQuality(10);
  animation.setRepeat(0);
  */
  background = loadImage("stars.jpg");
}

public void draw() {
  background(background);
  controller.run();
  
  /**
  Gif recording only
  if (i % 3 == 0) {
    animation.addFrame();
  }
  i++;
  */
}

public Vector getPositionFromMouse() {
  return new Vector(mouseX, mouseY); 
}

public float getRelativeToCanvasWidth(float rel) {
    return width * rel; 
}

public float getRelativeToCanvasHeight(float rel) {
    return height * rel; 
}
public class CelestialBody implements Drawable, Rotatable {
  private Vector position;
  private float radius;
  private Vector rotation;
  private Vector rotationDelta;
  private int bodyColor;
 
  public CelestialBody(float radius, Vector position, Vector rotationDelta, int bodyColor) {
    this.radius = radius; 
    this.position = position;
    this.rotation = new Vector();
    this.rotationDelta = rotationDelta;
    this.bodyColor = bodyColor;
  }
  
  public void rotate() {
    rotation = rotation.add(rotationDelta);
  }
  
  public void setPosition(Vector position) {
     this.position = position;
  }
  
  public Vector getPosition() {
    return this.position;
  }
  
  public float getRadius() {
    return this.radius;
  }

  public void setNewPosition(Vector position) {
    this.position = position;
  }

  public void draw() {
    pushMatrix();
    translate(position.getX(), position.getY(), position.getZ());
    rotateY(rotation.getY());
    rotateX(rotation.getX());
    noStroke();
    fill(bodyColor);
    sphere(radius);
    popMatrix();
  }
}
public static class Colors {
  public static int[] satelliteColors = new int[] {
    0xff616161,
    0xff9e9e9e,
    0xffbdbdbd,
    0xff424242,
    0xff546e7a,
    0xff37474f,
    0xff8d6e63,
    0xff263238,
    0xffb0bec5
  };
  
  public static int[] planetColors = new int[] {
    0xff827717,
    0xffafb42b,
    0xff2196f3,
    0xff512da8,
    0xffc2185b,
    0xff880e4f,
    0xffb71c1c,
    0xff004d40,
    0xff827717,
    0xff6d4c41,
    0xff80deea,
    0xffc0ca33
  };
  
  public static int[] starColors = new int[] {
    0xffffeb3b,
    0xfff9a825,
    0xffffeb3b,
    0xffffd54f,
    0xffffc107,
  };
    
    
}
public interface Drawable {
  public void draw();
}
public class Planet extends CelestialBody implements Translatable {
  private float translationDelta;
  private Satellite[] satellites;
  
  public Planet(float radius, Vector position, int bodyColor, Vector rotationDelta, float translationDelta, Satellite[] satellites) {
    super(radius, position, rotationDelta, bodyColor);
    this.translationDelta = translationDelta;
    this.satellites = satellites;
  }
  
  public void translate(Vector origin) {
    Vector pos = super.position.substract(origin);
    
    pos = new Vector( 
      pos.getX() * cos(translationDelta) - pos.getZ() * sin(translationDelta), 
      pos.getY(), 
      pos.getX() * sin(translationDelta) + pos.getZ() * cos(translationDelta)
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
public class PlanetarySystemController {
   private Star star;
   
   private final float maxRotationDelta = PI / 128;
   private final float maxTranslationDelta = PI / 128;
   private final Vector starPosition = new Vector(getRelativeToCanvasWidth(0.5f), getRelativeToCanvasHeight(0.5f), 0);
   
   public PlanetarySystemController() {
     star = new Star(
       100,
       starPosition,
       Colors.starColors[PApplet.parseInt(random(0, Colors.starColors.length))],
       new Vector(0, maxRotationDelta / 2),
       getRandomPlanets(100, starPosition)
     );
   }
   
   public Planet[] getRandomPlanets(float starRadius, Vector starPosition) {
     Planet[] planets = new Planet[PApplet.parseInt(random(4, 9))];
     float distance = starPosition.getX() - starRadius - getRelativeToCanvasWidth(0.25f);
     
     for (int i = 0; i < planets.length; i++) {
       float planetRadius = random(starRadius*0.35f, starRadius*0.55f);
       Vector planetPosition = new Vector(distance, starPosition.getY(), starPosition.getZ());
       Satellite[] satellites = getRandomSatellites(planetRadius, planetPosition);

       planets[i] = new Planet(
         planetRadius,
         planetPosition,
         Colors.planetColors[PApplet.parseInt(random(0, Colors.planetColors.length))],
         new Vector(0, random(-maxRotationDelta, maxRotationDelta)),
         random(-maxTranslationDelta, maxTranslationDelta),
         satellites
       );
       
       int lastIndex = satellites.length-1; 
       if (lastIndex > 0) {
        distance = satellites[lastIndex].getPosition().getX() - satellites[lastIndex].getRadius() - getRelativeToCanvasWidth(0.2f);
       }
     }
     
     return planets;
   }
   
   public Satellite[] getRandomSatellites(float planetRadius, Vector planetPosition) {
     Satellite[] satellites = new Satellite[PApplet.parseInt(random(0, 3))];
     float distance = planetPosition.getX() - planetRadius - getRelativeToCanvasWidth(0.05f);
     
     for (int i = 0; i < satellites.length; i++) {
       float satelliteRadius = random(planetRadius*0.2f, planetRadius*0.4f);
       
       satellites[i] = new Satellite(
         satelliteRadius,
         new Vector(distance, starPosition.getY(), starPosition.getZ()),
         Colors.satelliteColors[PApplet.parseInt(random(0, Colors.satelliteColors.length))],
         new Vector(0, random(-maxRotationDelta, maxRotationDelta)),
         random(-maxTranslationDelta*2, maxTranslationDelta*2)
       );
       
       distance -= satelliteRadius - getRelativeToCanvasWidth(0.05f);
     }
       
    return satellites;
   }
   
   
  
   public void run() {
     camera(
       getRelativeToCanvasWidth(0), 
       getRelativeToCanvasWidth(-1), 
       getRelativeToCanvasWidth(3.2f), 
       starPosition.getX(), starPosition.getY(), 
       starPosition.getZ(), 0, 1, 0);
     star.rotate();
     star.draw();
   }
}
public class Vector {
  private float x;
  private float y;
  private float z;
  
  public Vector() {
    this.x = 0;
    this.y = 0;
    this.z = 0;
  }
  
  public Vector(float x) {
    this.x = x;
    this.y = 0;
    this.z = 0;
  }
  
  public Vector(float x, float y) {
    this.x = x;
    this.y = y;
    this.z = 0;
  }
  
  public Vector(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public float getX(){
    return x;
  }

  public float getY() {
    return y;
  }
  
  public float getZ() {
    return z;
  }

  public void setX(float x){
    this.x = x;
  }

  public void setY(float y) {
    this.y = y;
  }
  
  public void setZ(float z) {
    this.z = z;
  }

  public Vector add(Vector other){
    return new Vector(getX() + other.getX(), getY() + other.getY(), getZ() + other.getZ());
  }
  
  public Vector substract(Vector other){
    return new Vector(getX() - other.getX(), getY() - other.getY(), getZ() - other.getZ());
  }
}
public interface Rotatable {
  public void rotate(); 
}
public class Satellite extends CelestialBody implements Translatable {
  private float translationDelta;

  public Satellite(float radius, Vector position, int bodyColor, Vector rotationDelta, float translationDelta) {
    super(radius, position, rotationDelta, bodyColor);
    this.translationDelta = translationDelta;
  }
  
  public void translate(Vector origin) {
    translate(origin, this.translationDelta);
  }
  
  public void translate(Vector origin, float translationDelta) {
    Vector pos = super.position.substract(origin);
    
    pos = new Vector( 
      pos.getX() * cos(translationDelta) - pos.getZ() * sin(translationDelta), 
      pos.getY(), 
      pos.getX() * sin(translationDelta) + pos.getZ() * cos(translationDelta)
    );
    
    super.position = pos.add(origin);
  }
  
  public void draw() {
    super.draw();
  }
}
public class Star extends CelestialBody {
  private Planet[] planets;
  
  public Star(float radius, Vector position, int bodyColor, Vector rotationDelta, Planet[] planets) {
    super(radius, position, rotationDelta, bodyColor);
    this.planets = planets;
  }

  public void draw() {
    pointLight(255, 255, 255, super.position.getX(), super.position.getY(), super.position.getZ());
    ambientLight(255, 255, 255, super.position.getX(), super.position.getY(), super.position.getZ());
    super.draw();
    
    for (Planet planet : planets) {
      planet.translate(super.position);
      planet.rotate();
      planet.draw();
    }
  }
}
public interface Translatable {
  public void translate(Vector origin); 
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "planetarySystem" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
