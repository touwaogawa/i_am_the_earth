// パーティクルマネージャークラス
class ParticleManager {
  ArrayList<Particle> particles;
  
  ParticleManager() {
    particles = new ArrayList<Particle>();
  }
  
  void createExplosion(float x, float y, color c, int count) {
    for (int i = 0; i < count; i++) {
      particles.add(new Particle(x, y, c));
    }
  }
  
  void update() {
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
  
  void render() {
    for (Particle p : particles) {
      p.render();
    }
  }
}
