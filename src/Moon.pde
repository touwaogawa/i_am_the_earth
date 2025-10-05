// ==========================================
// Moon.pde
// 継承: なし (独立クラス)
// 説明: 月クラス（Earthに所有される弾丸）
// 関連: Earthがインスタンスを持つ
// ==========================================

// 月クラス
class Moon {
  Earth owner;
  float x, y;
  float vx, vy;
  float radius;
  boolean isOrbiting;
  boolean isLaunched;
  boolean hasWater; // 水をまとっているか
  boolean passedThroughSun; // 太陽を通過したか
  boolean inGravityField; // 引力圏内にいるか
  boolean gravityEffectPlaying; // 引力音が再生中か
  
  // チャージ関連
  boolean isCharging;
  boolean chargeJustStarted;
  int chargeLevel; // 0~3
  float orbitAngle;
  float orbitSpeed;
  int chargeStartTime; // チャージ開始時刻（ミリ秒）
  float chargeDuration; // 1レベルあたりのチャージ時間（ミリ秒）
  
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
    this.chargeStartTime = 0;
    this.chargeDuration = 1000; // 1秒で1レベル（1000ミリ秒）
    this.passedThroughSun = false;
    this.inGravityField = false;
    this.gravityEffectPlaying = false;
  }
  
  void update() {
    if (isOrbiting) {
      // 地球の周りを周回
      float prevAngle = orbitAngle;
      orbitAngle += orbitSpeed;
      float distance = owner.radius + 20;
      x = owner.x + cos(orbitAngle) * distance;
      y = owner.y + sin(orbitAngle) * distance;
      
      // チャージ中は時間経過でサイズアップ
      if (isCharging) {
        // チャージ開始からの経過時間を計算（ミリ秒）
        int elapsedTime = millis() - chargeStartTime;
        
        // 経過時間から現在のチャージレベルを計算（最大3）
        int prevLevel = chargeLevel;
        chargeLevel = min(3, (int)(elapsedTime / chargeDuration));
        
        // レベルが上がったら成長音を再生
        if (chargeLevel > prevLevel) {
          SoundManager.playGrow();
        }
      }
      
      // 角度を正規化
      if (orbitAngle >= TWO_PI) {
        orbitAngle -= TWO_PI;
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
    
    // 引力を受けている時の表示（紫の輝き）
    if (inGravityField && isLaunched) {
      for (int i = 0; i < 3; i++) {
        noFill();
        stroke(150, 100, 200, 100 - i * 30);
        strokeWeight(2);
        ellipse(x, y, (size + i * 8) * 2, (size + i * 8) * 2);
      }
    }
    
    // 水のエフェクト（水星風の半透明の水の層）
    if (hasWater) {
      fill(100, 150, 255, 100);
      noStroke();
      ellipse(x, y, size * 3, size * 3);
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
  
  // チャージ開始（ボタンを押した瞬間に呼ばれる）
  void startCharging() {
    if (isOrbiting && !isCharging) {
      isCharging = true;
      chargeJustStarted = true;
      chargeLevel = 0;
      // ボタンを押した瞬間の時刻を記録
      chargeStartTime = millis();
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
    chargeStartTime = 0;
    orbitAngle = 0;
    vx = 0;
    vy = 0;
    hasWater = false; // 水もリセット
    passedThroughSun = false;
    inGravityField = false;
    gravityEffectPlaying = false;
  }
  
  boolean checkCollision(Earth earth) {
    // 地球との当たり判定（発射前でも当たる）
    float distance = dist(x, y, earth.x, earth.y);
    float size = radius + chargeLevel * 5;
    return distance < (size + earth.radius);
  }
  
  boolean checkCollisionWithMoon(Moon otherMoon) {
    // 他の月との当たり判定
    // 発射済みの月とのみ判定
    if (!this.isLaunched && !otherMoon.isLaunched) return false;
    
    float distance = dist(x, y, otherMoon.x, otherMoon.y);
    float thisSize = radius + chargeLevel * 5;
    float otherSize = otherMoon.radius + otherMoon.chargeLevel * 5;
    return distance < (thisSize + otherSize);
  }
}
