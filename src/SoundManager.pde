// サウンドマネージャークラス
import processing.sound.*;

static class SoundManager {
  static boolean soundEnabled = true;
  static boolean soundInitialized = false;
  
  // サウンドファイル
  static SoundFile launchSound;
  static SoundFile hitSound;
  static SoundFile explosionSound;
  static SoundFile burnSound;
  static SoundFile splashSound;
  static SoundFile gravitySound;
  
  static void init(PApplet app) {
    try {
      // サウンドファイルの読み込み
      String soundPath = "Sounds/";
      
      // 各サウンドファイルを読み込み(ファイルが存在する場合のみ)
      try { launchSound = new SoundFile(app, soundPath + "launch.mp3"); } catch (Exception e) { println("launch.mp3 not found"); }
      try { hitSound = new SoundFile(app, soundPath + "hit.mp3"); } catch (Exception e) { println("hit.mp3 not found"); }
      try { explosionSound = new SoundFile(app, soundPath + "explosion.mp3"); } catch (Exception e) { println("explosion.mp3 found"); }
      try { burnSound = new SoundFile(app, soundPath + "burn.mp3"); } catch (Exception e) { println("burn.mp3 not found"); }
      try { splashSound = new SoundFile(app, soundPath + "splash.mp3"); } catch (Exception e) { println("splash.mp3 not found"); }
      try { gravitySound = new SoundFile(app, soundPath + "gravity.mp3"); } catch (Exception e) { println("gravity.mp3 not found"); }
      
      soundInitialized = true;
      println("Sound system initialized");
    } catch (Exception e) {
      println("Sound library not available: " + e.getMessage());
      soundInitialized = false;
    }
  }
  
  static void playLaunch() {
    if (!soundEnabled || !soundInitialized) return;
    if (launchSound != null) launchSound.play();
  }
  
  static void playHit() {
    if (!soundEnabled || !soundInitialized) return;
    if (hitSound != null) hitSound.play();
  }
  
  static void playExplosion() {
    if (!soundEnabled || !soundInitialized) return;
    if (explosionSound != null) explosionSound.play();
  }
  
  static void playBurn() {
    if (!soundEnabled || !soundInitialized) return;
    if (burnSound != null) burnSound.play();
  }
  
  static void playWaterSplash() {
    if (!soundEnabled || !soundInitialized) return;
    if (splashSound != null) splashSound.play();
  }
  
  static void playGravityEffect() {
    if (!soundEnabled || !soundInitialized) return;
    if (gravitySound != null) gravitySound.play();
  }
  
  static void toggleSound() {
    soundEnabled = !soundEnabled;
    println("Sound: " + (soundEnabled ? "ON" : "OFF"));
  }
}
