// サウンドマネージャークラス（シンプルな音声システム）
static class SoundManager {
  static boolean soundEnabled = true;
  
  static void playLaunch() {
    if (!soundEnabled) return;
    // Processing の sound ライブラリがない場合はコンソールに出力
    println("♪ Launch!");
  }
  
  static void playHit() {
    if (!soundEnabled) return;
    println("♪ Hit!");
  }
  
  static void playExplosion() {
    if (!soundEnabled) return;
    println("♪ Explosion!");
  }
  
  static void playBurn() {
    if (!soundEnabled) return;
    println("♪ Burn!");
  }
  
  static void playWaterSplash() {
    if (!soundEnabled) return;
    println("♪ Splash!");
  }
  
  static void toggleSound() {
    soundEnabled = !soundEnabled;
    println("Sound: " + (soundEnabled ? "ON" : "OFF"));
  }
}
