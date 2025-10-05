// パーティクルクラス
class Particle {
  float x, y;
  float vx, vy;
  color particleColor;
  float life;
  float maxLife;
  float size;
  
  Particle(float x, float y, color c) {
    this.x = x;
    this.y = y;
    this.particleColor = c;
    this.maxLife = 60;
    this.life = maxLife;
    this.size = random(3, 8);
    
    // ランダムな方向に飛ぶ
    float angle = random(TWO_PI);
    float speed = random(2, 6);
    this.vx = cos(angle) * speed;
    this.vy = sin(angle) * speed;
  }
  
  void update() {
    x += vx;
    y += vy;
    life--;
    
    // 重力効果
    vy += 0.1;
    
    // 減速
    vx *= 0.98;
    vy *= 0.98;
  }
  
  void render() {
    float alpha = map(life, 0, maxLife, 0, 255);
    fill(red(particleColor), green(particleColor), blue(particleColor), alpha);
    noStroke();
    ellipse(x, y, size, size);
  }
  
  boolean isDead() {
    return life <= 0;
  }
}
