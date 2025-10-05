// ==========================================
// Earth.pde
// 継承: Planet
// 説明: 地球クラス（プレイヤーが操作、Moonを所有）
// 継承ツリー:
//   CelestialBody → Planet → Earth (このファイル)
// ==========================================

// 地球クラス
class Earth extends Planet {
  int playerId;
  char controlKey;
  Moon moon;
  boolean isDestroyed;

  Earth(float orbitDistance, int playerId, char key, float angleOffset) {
    super(30, getPlayerColor(playerId), "Earth P" + (playerId + 1), orbitDistance, 0.01, angleOffset);
    this.playerId = playerId;
    this.controlKey = key;
    this.isDestroyed = false;
    
    // 月を生成
    moon = new Moon(this);
  }
  
  void update() {
    if (isDestroyed) return;
    super.update();
    
    // 月を更新
    moon.update();
  }
  
  void render() {
    if (isDestroyed) return;
    
    // 軌道を描画
    drawOrbit();
    
    // 地球を描画
    fill(bodyColor);
    stroke(255);
    strokeWeight(2);
    ellipse(x, y, radius * 2, radius * 2);
    
    // プレイヤー番号を縁取り文字で表示
    drawOutlinedText("P" + (playerId + 1), x, y, 20, color(255), color(0), 3);
    
    // 月を描画
    moon.render();
  }
  
  // 縁取り文字を描画
  void drawOutlinedText(String txt, float px, float py, int size, color fillCol, color strokeCol, int strokeW) {
    textAlign(CENTER, CENTER);
    textSize(size);
    
    // 縁取り
    fill(strokeCol);
    for (int dx = -strokeW; dx <= strokeW; dx++) {
      for (int dy = -strokeW; dy <= strokeW; dy++) {
        if (dx != 0 || dy != 0) {
          text(txt, px + (float)dx, py + (float)dy);
        }
      }
    }
    
    // 本体
    fill(fillCol);
    text(txt, px, py);
  }
  
  void handleKeyPressed(char k) {
    if (k == controlKey) {
      moon.startCharging();
      orbitSpeed = 0.01 * 0.3; // チャージ中は公転が遅くなる
    }
  }
  
  void handleKeyReleased(char k) {
    if (k == controlKey) {
      moon.launch();
      orbitSpeed = 0.01; // 公転速度を戻す
    }
  }
  
  void destroy(ParticleManager pm) {
    isDestroyed = true;
    SoundManager.playExplosion();
    // 爆発エフェクト
    pm.createExplosion(x, y, bodyColor, 40);
  }
}
