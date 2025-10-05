// 月クラス
class Moon {
  Earth owner;
  float x, y;
  float vx, vy;
  float radius;
  boolean isOrbiting;
  boolean isLaunched;
  boolean hasWater; // 水をまとっているか
  
  // チャージ関連
  boolean isCharging;
  boolean chargeJustStarted;
  int chargeLevel; // 0~3
  float orbitAngle;
  float orbitSpeed;
  float chargeCycles; // チャージ中の周回数
  
  Moon(Earth owner) {
    this.owner = owner;
    this.radius = 10;
    this.isOrbiting = true;
    this.isLaunched = false;
    this.isCharging = false;
    this.chargeJustStarted = false;
    this.chargeLevel = 0;
    this.orbitAngle = 0;
    this.orbitSpeed = 0.05;
    this.hasWater = false;
    this.chargeCycles = 0;
  }
  
  void update() {
    if (isOrbiting) {
      // 地球の周りを周回
      float prevAngle = orbitAngle;
      orbitAngle += orbitSpeed;
      float distance = owner.radius + 20;
      x = owner.x + cos(orbitAngle) * distance;
      y = owner.y + sin(orbitAngle) * distance;
      
      // チャージ中は周回ごとにサイズアップ
      if (isCharging) {
        // 1周したかチェック
        if (prevAngle < TWO_PI && orbitAngle >= TWO_PI) {
          chargeCycles++;
          if (chargeCycles <= 3) {
            chargeLevel = (int)chargeCycles;
          }
        }
        // 角度を正規化
        if (orbitAngle >= TWO_PI) {
          orbitAngle -= TWO_PI;
        }
      }
    } else if (isLaunched) {
      // 発射後の移動
      x += vx;
      y += vy;
      
      // 画面外に出たらリセット
      if (x < -50 || x > width + 50 || y < -50 || y > height + 50) {
        reset();
      }
    }
  }
  
  void render() {
    if (!isOrbiting && !isLaunched) return;
    
    float size = radius + chargeLevel * 5;
    
    // 水のエフェクト
    if (hasWater) {
      fill(100, 150, 255, 150);
      noStroke();
      ellipse(x, y, size * 2.5, size * 2.5);
    }
    
    // 月本体
    fill(200, 200, 200);
    stroke(255);
    strokeWeight(1);
    ellipse(x, y, size * 2, size * 2);
    
    // チャージレベル表示
    if (isCharging && isOrbiting) {
      fill(255, 255, 0);
      noStroke();
      for (int i = 0; i < chargeLevel; i++) {
        float angle = TWO_PI * i / 3;
        float px = x + cos(angle) * (size + 5);
        float py = y + sin(angle) * (size + 5);
        ellipse(px, py, 3, 3);
      }
    }
  }
  
  void startCharging() {
    if (isOrbiting && !isCharging) {
      isCharging = true;
      chargeJustStarted = true;
      chargeCycles = 0;
      chargeLevel = 0;
    }
  }
  
  void launch() {
    if (isOrbiting && isCharging) {
      isOrbiting = false;
      isLaunched = true;
      isCharging = false;
      
      // 発射音
      SoundManager.playLaunch();
      
      // 発射方向を接線方向（回転の慣性方向）に設定
      float speed = 5 + chargeLevel * 2;
      // 接線方向は法線方向（orbitAngle）に垂直
      float tangentAngle = orbitAngle + HALF_PI;
      vx = cos(tangentAngle) * speed;
      vy = sin(tangentAngle) * speed;
    }
  }
  
  void reset() {
    isOrbiting = true;
    isLaunched = false;
    isCharging = false;
    chargeJustStarted = false;
    chargeLevel = 0;
    chargeCycles = 0;
    orbitAngle = 0;
    vx = 0;
    vy = 0;
    hasWater = false; // 水もリセット
  }
  
  boolean checkCollision(Earth earth) {
    if (!isLaunched) return false;
    
    float distance = dist(x, y, earth.x, earth.y);
    float size = radius + chargeLevel * 5;
    return distance < (size + earth.radius);
  }
}
