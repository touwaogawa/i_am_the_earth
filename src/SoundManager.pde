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
  static SoundFile joinSound;
  static SoundFile startSound;
  static SoundFile retrySound;
  static SoundFile growSound;
  static SoundFile applauseSound;
  
  // BGM
  static SoundFile titleBGM;
  static SoundFile battleBGM;
  static SoundFile resultJingle;
  
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
      try { joinSound = new SoundFile(app, soundPath + "join.mp3"); } catch (Exception e) { println("join.mp3 not found"); }
      try { startSound = new SoundFile(app, soundPath + "start.mp3"); } catch (Exception e) { println("start.mp3 not found"); }
      try { retrySound = new SoundFile(app, soundPath + "retry.mp3"); } catch (Exception e) { println("retry.mp3 not found"); }
      try { growSound = new SoundFile(app, soundPath + "grow.mp3"); } catch (Exception e) { println("grow.mp3 not found"); }
      try { applauseSound = new SoundFile(app, soundPath + "applause.mp3"); } catch (Exception e) { println("applause.mp3 not found"); }
      
      // BGMを読み込み
      try { titleBGM = new SoundFile(app, soundPath + "title_bgm.mp3"); } catch (Exception e) { println("title_bgm.mp3 not found"); }
      try { battleBGM = new SoundFile(app, soundPath + "battle_bgm.mp3"); } catch (Exception e) { println("battle_bgm.mp3 not found"); }
      try { resultJingle = new SoundFile(app, soundPath + "result_jingle.mp3"); } catch (Exception e) { println("result_jingle.mp3 not found"); }
      
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
  
  static void playJoin() {
    if (!soundEnabled || !soundInitialized) return;
    if (joinSound != null) joinSound.play();
  }
  
  static void playStart() {
    if (!soundEnabled || !soundInitialized) return;
    if (startSound != null) startSound.play();
  }
  
  static void playRetry() {
    if (!soundEnabled || !soundInitialized) return;
    if (retrySound != null) retrySound.play();
  }
  
  static void playGrow() {
    if (!soundEnabled || !soundInitialized) return;
    if (growSound != null) growSound.play();
  }
  
  static void playApplause() {
    if (!soundEnabled || !soundInitialized) return;
    if (applauseSound != null) applauseSound.play();
  }
  
  // BGM制御
  static void playTitleBGM() {
    if (!soundEnabled || !soundInitialized) return;
    stopAllBGM();
    if (titleBGM != null) {
      titleBGM.amp(0.3); // BGMの音量は30%に設定
      titleBGM.loop();
    }
  }
  
  static void playBattleBGM() {
    if (!soundEnabled || !soundInitialized) return;
    stopAllBGM();
    if (battleBGM != null) {
      battleBGM.amp(0.3); // BGMの音量は30%に設定
      battleBGM.loop();
    }
  }
  
  static void playResultJingle() {
    if (!soundEnabled || !soundInitialized) return;
    stopAllBGM();
    if (resultJingle != null) {
      resultJingle.amp(0.3); // ジングルの音量は30%に設定
      resultJingle.play();
    }
  }
  
  static void stopAllBGM() {
    if (titleBGM != null) titleBGM.stop();
    if (battleBGM != null) battleBGM.stop();
    if (resultJingle != null) resultJingle.stop();
  }
  
  static void toggleSound() {
    soundEnabled = !soundEnabled;
    println("Sound: " + (soundEnabled ? "ON" : "OFF"));
  }
}
