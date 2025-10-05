// ==========================================
// Planet.pde
// 継承: CelestialBody
// 説明: 惑星の抽象クラス（軌道運動を実装）
// 継承ツリー:
//   CelestialBody
//   └─ Planet (このファイル)
//      ├─ Earth
//      ├─ Mercury
//      └─ Venus
// ==========================================

// 惑星の基底クラス
abstract class Planet extends CelestialBody {
  protected float orbitAngle;
  protected float orbitSpeed;
  protected float orbitDistance;
  
  Planet(float radius, color c, String name, float orbitDistance, float orbitSpeed, float startAngle) {
    super(0, 0, radius, c, name);
    this.orbitDistance = orbitDistance;
    this.orbitSpeed = orbitSpeed;
    this.orbitAngle = startAngle;
  }
  
  void update() {
    // 太陽の周りを公転
    orbitAngle += orbitSpeed;
    x = width/2 + cos(orbitAngle) * orbitDistance;
    y = height/2 + sin(orbitAngle) * orbitDistance;
  }
  
  void render() {
    // 軌道の線を描画
    drawOrbit();
    
    // 惑星本体
    fill(bodyColor);
    stroke(255);
    strokeWeight(2);
    ellipse(x, y, radius * 2, radius * 2);
    
    // 名前表示
    drawName();
  }
  
  void drawOrbit() {
    noFill();
    stroke(255, 255, 255, 30);
    strokeWeight(1);
    ellipse(width/2, height/2, orbitDistance * 2, orbitDistance * 2);
  }
  
  void drawName() {
    fill(255);
    textAlign(CENTER);
    textSize(10);
    text(name, x, y + radius + 12);
  }
}
