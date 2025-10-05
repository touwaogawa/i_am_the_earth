// ==========================================
// Sun.pde
// 継承: CelestialBody
// 説明: 太陽クラス（中心に固定、引力を持つ）
// 継承ツリー:
//   CelestialBody
//   └─ Sun (このファイル)
// ==========================================

// 太陽クラス
class Sun extends CelestialBody {
  float gravityStrength;
  float gravityRange; // 引力圏の範囲
  
  Sun(float x, float y, float radius) {
    super(x, y, radius, color(255, 200, 0), "Sun");
    gravityStrength = 2500; // 引力の強さ（強化）
    gravityRange = 150; // 引力圏の範囲（水星の軌道くらい）
  }
  
  void update() {
    // 太陽は動かない
  }
  
  void render() {
    // 引力圏の薄紫のもや（一番後ろに描画）
    noFill();
    stroke(150, 100, 200, 80);
    strokeWeight(2);
    for (int i = 0; i < 5; i++) {
      float alpha = map(i, 0, 5, 100, 20);
      stroke(150, 100, 200, alpha);
      ellipse(x, y, gravityRange * 2 - i * 10, gravityRange * 2 - i * 10);
    }
    
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
    
    // 引力圏内かチェック
    boolean inGravityRange = distance <= gravityRange;
    moon.inGravityField = inGravityRange;
    
    if (inGravityRange && distance > 0) {
      // 引力の計算
      float force = gravityStrength / (distance * distance);
      force = constrain(force, 0, 3); // 最大値を制限
      
      // 正規化して力を加える
      float nx = dx / distance;
      float ny = dy / distance;
      
      moon.vx += nx * force;
      moon.vy += ny * force;
      
      // 引力を受けている音を再生
      if (!moon.gravityEffectPlaying) {
        SoundManager.playGravityEffect();
        moon.gravityEffectPlaying = true;
      }
    } else {
      moon.gravityEffectPlaying = false;
    }
  }
  
  void checkCollision(Moon moon, ParticleManager pm) {
    if (!moon.isLaunched) return;
    
    float distance = dist(x, y, moon.x, moon.y);
    float moonSize = moon.radius + moon.chargeLevel * 5;
    
    // 太陽の内部に入った時の処理
    if (distance < radius + moonSize) {
      if (moon.hasWater) {
        // 水をまとった月は太陽の内部に入っても通過できる
        // 太陽の中心を通過したら水が蒸発
        if (!moon.passedThroughSun && distance < radius * 0.3) {
          moon.passedThroughSun = true;
        }
      } else {
        // 水がない月は太陽に衝突して破壊
        SoundManager.playBurn();
        pm.createExplosion(moon.x, moon.y, color(255, 150, 0), 20);
        moon.reset();
      }
    } else {
      // 太陽の外に出たら水を蒸発させる
      if (moon.hasWater && moon.passedThroughSun) {
        moon.hasWater = false;
        moon.passedThroughSun = false;
        SoundManager.playBurn();
        // 蒸気エフェクト
        pm.createExplosion(moon.x, moon.y, color(200, 200, 255), 15);
      }
    }
  }
}
