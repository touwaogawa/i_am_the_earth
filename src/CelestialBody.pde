// 天体の基底クラス
abstract class CelestialBody {
  protected float x, y;
  protected float radius;
  protected color bodyColor;
  protected String name;
  
  CelestialBody(float x, float y, float radius, color c, String name) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.bodyColor = c;
    this.name = name;
  }
  
  abstract void update();
  abstract void render();
  
  float getX() { return x; }
  float getY() { return y; }
  float getRadius() { return radius; }
}
