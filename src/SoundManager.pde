// サウンドマネージャークラス（シンプルな音声システム）
import processing.sound.*;

static class SoundManager {
  static boolean soundEnabled = true;
  static SoundFile launchSound;
  static SoundFile hitSound;
  static SoundFile explosionSound;
  static SoundFile burnSound;
  static SoundFile splashSound;
  static SoundFile gravitySound;
  
  static void init(PApplet app) {
    // 音声ファイルの読み込み(ファイルが存在する場合のみ)
    try {
      launchSound = loadSoundSafe(app, "Sounds/launch.mp3", "Sounds/launch.wav");
    } catch (Exception e) {
      println("Launch sound not found");
    }
    
    try {
      hitSound = loadSoundSafe(app, "Sounds/hit.mp3", "Sounds/hit.wav");
    } catch (Exception e) {
      println("Hit sound not found");
    }
    
    try {
      explosionSound = loadSoundSafe(app, "Sounds/explosion.mp3", "Sounds/explosion.wav");
    } catch (Exception e) {
      println("Explosion sound not found");
    }
    
    try {
      burnSound = loadSoundSafe(app, "Sounds/burn.mp3", "Sounds/burn.wav");
    } catch (Exception e) {
      println("Burn sound not found");
    }
    
    try {
      splashSound = loadSoundSafe(app, "Sounds/splash.mp3", "Sounds/splash.wav");
    } catch (Exception e) {
      println("Splash sound not found");
    }
    
    try {
      gravitySound = loadSoundSafe(app, "Sounds/gravity.mp3", "Sounds/gravity.wav");
    } catch (Exception e) {
      println("Gravity sound not found");
    }
  }
  
  // mp3またはwavファイルを安全に読み込む
  static SoundFile loadSoundSafe(PApplet app, String path1, String path2) {
    try {
      return new SoundFile(app, path1);
    } catch (Exception e1) {
      try {
        return new SoundFile(app, path2);
      } catch (Exception e2) {
        throw new RuntimeException("Sound file not found: " + path1 + " or " + path2);
      }
    }
  }
  
  static void playLaunch() {
    if (!soundEnabled) return;
    if (launchSound != null) {
      launchSound.play();
    } else {
      println("♪ Launch!");
    }
  }
  
  static void playHit() {
    if (!soundEnabled) return;
    if (hitSound != null) {
      hitSound.play();
    } else {
      println("♪ Hit!");
    }
  }
  
  static void playExplosion() {
    if (!soundEnabled) return;
    if (explosionSound != null) {
      explosionSound.play();
    } else {
      println("♪ Explosion!");
    }
  }
  
  static void playBurn() {
    if (!soundEnabled) return;
    if (burnSound != null) {
      burnSound.play();
    } else {
      println("♪ Burn!");
    }
  }
  
  static void playWaterSplash() {
    if (!soundEnabled) return;
    if (splashSound != null) {
      splashSound.play();
    } else {
      println("♪ Splash!");
    }
  }
  
  static void playGravityEffect() {
    if (!soundEnabled) return;
    if (gravitySound != null) {
      gravitySound.play();
    } else {
      println("♪ Gravity Pull!");
    }
  }
  
  static void toggleSound() {
    soundEnabled = !soundEnabled;
    println("Sound: " + (soundEnabled ? "ON" : "OFF"));
  }
}
