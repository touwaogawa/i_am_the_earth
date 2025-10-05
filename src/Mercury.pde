// 水星クラス
class Mercury extends Planet {
  boolean hasWater;
  int waterTimer;
  int waterRegenTime;
  
  Mercury() {
    super(20, color(150, 150, 150), "Mercury", 150, 0.008, PI / 4);
    this.hasWater = true;
    this.waterTimer = 0;
    this.waterRegenTime = 180; // 3秒（60fps × 3）
  }
  
  void update() {
    super.update();
    
    // 水の再生成タイマー
    if (!hasWater) {
      waterTimer++;
      if (waterTimer >= waterRegenTime) {
        hasWater = true;
        waterTimer = 0;
      }
    }
  }
  
  void render() {
    // 軌道を描画
    drawOrbit();
    
    if (hasWater) {
      // 水をまとった状態
      fill(100, 150, 255, 100);
      noStroke();
      ellipse(x, y, radius * 3, radius * 3);
    }
    
    // 水星本体
    fill(bodyColor);
    stroke(255);
    strokeWeight(2);
    ellipse(x, y, radius * 2, radius * 2);
    
    // 名前表示
    drawName();
    
    // 水の再生タイマー表示
    if (!hasWater && waterTimer > 0) {
      fill(100, 150, 255);
      textAlign(CENTER);
      textSize(10);
      float remaining = (waterRegenTime - waterTimer) / 60.0;
      text(nf(remaining, 1, 1) + "s", x, y);
    }
  }
  
  boolean checkCollision(Moon moon) {
    if (!moon.isLaunched) return false;
    
    float distance = dist(x, y, moon.x, moon.y);
    float moonSize = moon.radius + moon.chargeLevel * 5;
    return distance < (radius + moonSize);
  }
  
  void giveWater(Moon moon) {
    if (hasWater && !moon.hasWater) {
      moon.hasWater = true;
      hasWater = false;
      waterTimer = 0; // タイマーリセット
      SoundManager.playWaterSplash();
    }
  }
}
