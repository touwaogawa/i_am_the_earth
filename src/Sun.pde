// 太陽クラス
class Sun extends CelestialBody {
  float gravityStrength;
  
  Sun(float x, float y, float radius) {
    super(x, y, radius, color(255, 200, 0), "Sun");
    gravityStrength = 100; // 引力の強さ
  }
  
  void update() {
    // 太陽は動かない
  }
  
  void render() {
    // 太陽の描画
    fill(bodyColor);
    stroke(255, 150, 0);
    strokeWeight(3);
    ellipse(x, y, radius * 2, radius * 2);
    
    // 光のエフェクト
    noFill();
    stroke(255, 200, 0, 100);
    strokeWeight(2);
    for (int i = 1; i <= 3; i++) {
      ellipse(x, y, radius * 2 + i * 10, radius * 2 + i * 10);
    }
    
    // "Sun"という文字を表示
    fill(255);
    stroke(0);
    strokeWeight(2);
    textAlign(CENTER, CENTER);
    textSize(16);
    text("Sun", x, y);
  }
  
  // 月に引力を加える
  void applyGravity(Moon moon) {
    if (!moon.isLaunched) return;
    
    float dx = x - moon.x;
    float dy = y - moon.y;
    float distance = sqrt(dx * dx + dy * dy);
    
    if (distance > 0) {
      // 引力の計算
      float force = gravityStrength / (distance * distance);
      force = constrain(force, 0, 2); // 最大値を制限
      
      // 正規化して力を加える
      float nx = dx / distance;
      float ny = dy / distance;
      
      moon.vx += nx * force;
      moon.vy += ny * force;
    }
  }
  
  void checkCollision(Moon moon, ParticleManager pm) {
    if (!moon.isLaunched) return;
    
    float distance = dist(x, y, moon.x, moon.y);
    float moonSize = moon.radius + moon.chargeLevel * 5;
    
    if (distance < radius + moonSize) {
      if (moon.hasWater) {
        // 水をまとった月は水が蒸発するだけ
        moon.hasWater = false;
        SoundManager.playBurn();
        // 蒸気エフェクト
        pm.createExplosion(moon.x, moon.y, color(200, 200, 255), 15);
      } else {
        // 太陽に侵入したら月を破壊
        SoundManager.playBurn();
        pm.createExplosion(moon.x, moon.y, color(255, 150, 0), 20);
        moon.reset();
      }
    }
  }
}
