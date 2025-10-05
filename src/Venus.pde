// ==========================================
// Venus.pde
// 継承: Planet
// 説明: 金星クラス（3回の攻撃で破壊可能な障害物）
// 継承ツリー:
//   CelestialBody → Planet → Venus (このファイル)
// ==========================================

// 金星クラス
class Venus extends Planet {
  int hitCount;
  int maxHits;
  boolean isDestroyed;
  
  Venus() {
    super(25, color(255, 200, 100), "Venus", 220, 0.006, PI * 3 / 4);
    this.hitCount = 0;
    this.maxHits = 3;
    this.isDestroyed = false;
  }
  
  void update() {
    if (isDestroyed) return;
    super.update();
  }
  
  void render() {
    if (isDestroyed) return;
    
    // 軌道を描画
    drawOrbit();
    
    // 金星本体
    fill(bodyColor);
    stroke(255);
    strokeWeight(2);
    ellipse(x, y, radius * 2, radius * 2);
    
    // ダメージ表示
    fill(255, 0, 0);
    stroke(0);
    strokeWeight(2);
    textAlign(CENTER, CENTER);
    textSize(15);
    text(hitCount + "/" + maxHits, x, y);
    
    // 名前表示
    drawName();
  }
  
  boolean checkCollision(Moon moon) {
    if (isDestroyed || !moon.isLaunched) return false;
    
    float distance = dist(x, y, moon.x, moon.y);
    float moonSize = moon.radius + moon.chargeLevel * 5;
    return distance < (radius + moonSize);
  }
  
  void hit(ParticleManager pm) {
    hitCount++;
    SoundManager.playHit();
    
    // パーティクル生成
    pm.createExplosion(x, y, bodyColor, 10);
    
    if (hitCount >= maxHits) {
      destroy(pm);
    }
  }
  
  void destroy(ParticleManager pm) {
    isDestroyed = true;
    SoundManager.playExplosion();
    // 大きな爆発エフェクト
    pm.createExplosion(x, y, bodyColor, 30);
  }
}
