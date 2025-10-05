// ゲーム全体を管理するクラス
class Game {
  ArrayList<Earth> earths;
  Sun sun;
  Mercury mercury;
  Venus venus;
  ParticleManager particleManager;
  
  // ゲーム状態
  GameState gameState;
  int winner;
  
  // タイトル画面用
  boolean[] playerJoined;
  char[] playerKeys;
  
  // ヒットストップ・画面振動
  int hitStopTimer;
  float screenShakeX, screenShakeY;
  int shakeTimer;
  
  Game() {
    sun = new Sun(width/2, height/2, 80);
    mercury = new Mercury();
    venus = new Venus();
    particleManager = new ParticleManager();
    
    gameState = GameState.TITLE;
    winner = -1;
    
    // プレイヤーのキー設定（Q, P, Z, M）
    playerKeys = new char[]{'q', 'p', 'z', 'm'};
    playerJoined = new boolean[4];
    
    earths = new ArrayList<Earth>();
    
    hitStopTimer = 0;
    screenShakeX = 0;
    screenShakeY = 0;
    shakeTimer = 0;
  }
  
  void update() {
    if (gameState == GameState.TITLE) {
      updateTitle();
    } else if (gameState == GameState.PLAYING) {
      updatePlaying();
    }
    
    // 画面振動の減衰
    if (shakeTimer > 0) {
      shakeTimer--;
      screenShakeX = random(-shakeTimer/2.0, shakeTimer/2.0);
      screenShakeY = random(-shakeTimer/2.0, shakeTimer/2.0);
    } else {
      screenShakeX = 0;
      screenShakeY = 0;
    }
  }
  
  void updateTitle() {
    // タイトル画面では何もしない
  }
  
  void updatePlaying() {
    // ヒットストップ中は更新しない
    if (hitStopTimer > 0) {
      hitStopTimer--;
      return;
    }
    
    // 太陽の更新
    sun.update();
    
    // 水星の更新
    mercury.update();
    
    // 金星の更新
    venus.update();
    
    // パーティクルの更新
    particleManager.update();
    
    // 地球の更新
    for (int i = earths.size() - 1; i >= 0; i--) {
      Earth earth = earths.get(i);
      earth.update();
      
      // 太陽の引力を適用
      sun.applyGravity(earth.moon);
      
      // 太陽との衝突判定
      sun.checkCollision(earth.moon, particleManager);
      
      // 水星との衝突判定
      if (mercury.checkCollision(earth.moon)) {
        mercury.giveWater(earth.moon);
        particleManager.createExplosion(earth.moon.x, earth.moon.y, color(100, 150, 255), 10);
      }
      
      // 金星との衝突判定
      if (venus.checkCollision(earth.moon)) {
        venus.hit(particleManager);
        earth.moon.reset();
      }
      
      // 他の地球との衝突判定
      for (int j = 0; j < earths.size(); j++) {
        if (i != j) {
          Earth other = earths.get(j);
          if (earth.moon.checkCollision(other)) {
            other.destroy(particleManager);
            earth.moon.reset();
            
            // ヒットストップと画面振動
            hitStopTimer = 10;
            shakeTimer = 20;
          }
        }
      }
      
      // 脱落した地球を削除
      if (earth.isDestroyed) {
        earths.remove(i);
      }
    }
    
    // 勝利判定
    if (earths.size() == 1) {
      gameState = GameState.GAME_OVER;
      winner = earths.get(0).playerId;
    } else if (earths.size() == 0) {
      gameState = GameState.GAME_OVER;
      winner = -1;
    }
  }
  
  void render() {
    background(20);
    
    // 画面振動を適用
    pushMatrix();
    translate(screenShakeX, screenShakeY);
    
    if (gameState == GameState.TITLE) {
      renderTitle();
    } else if (gameState == GameState.PLAYING || gameState == GameState.GAME_OVER) {
      renderGame();
      
      if (gameState == GameState.GAME_OVER) {
        renderGameOver();
      }
    }
    
    popMatrix();
  }
  
  void renderTitle() {
    // タイトル
    fill(255);
    textAlign(CENTER);
    textSize(64);
    text("I am the Earth", width/2, height/3);
    
    // プレイヤー参加状態
    textSize(24);
    text("Press key to join:", width/2, height/2 - 60);
    
    for (int i = 0; i < 4; i++) {
      float y = height/2 + i * 40;
      if (playerJoined[i]) {
        fill(getPlayerColor(i));
        text("P" + (i+1) + " [" + Character.toUpperCase(playerKeys[i]) + "] - Joined!", width/2, y);
      } else {
        fill(150);
        text("P" + (i+1) + " [" + Character.toUpperCase(playerKeys[i]) + "] - Press to join", width/2, y);
      }
    }
    
    // スタート表示
    int joinedCount = 0;
    for (boolean joined : playerJoined) {
      if (joined) joinedCount++;
    }
    
    if (joinedCount >= 2) {
      fill(255, 255, 0);
      textSize(32);
      text("Press SPACE to Start!", width/2, height - 100);
    } else {
      fill(150);
      textSize(20);
      text("At least 2 players required", width/2, height - 100);
    }
  }
  
  void renderGame() {
    // 太陽を描画
    sun.render();
    
    // 水星を描画
    mercury.render();
    
    // 金星を描画
    venus.render();
    
    // 地球を描画
    for (Earth earth : earths) {
      earth.render();
    }
    
    // パーティクルを描画
    particleManager.render();
    
    // UI表示
    fill(255);
    textAlign(LEFT);
    textSize(14);
    text("Players alive: " + earths.size(), 10, 20);
    text("M: Toggle Sound", 10, 40);
  }
  
  void renderGameOver() {
    fill(0, 0, 0, 150);
    rect(0, 0, width, height);
    
    fill(255, 255, 255, 200);
    textAlign(CENTER);
    textSize(48);
    if (winner >= 0) {
      text("Player " + (winner + 1) + " Wins!", width/2, height/2);
    } else {
      text("Draw!", width/2, height/2);
    }
    textSize(24);
    text("Press R to Restart", width/2, height/2 + 50);
  }
  
  void handleKeyPressed(char k) {
    k = Character.toLowerCase(k);
    
    // サウンドのトグル
    if (k == 'b') {
      SoundManager.toggleSound();
      return;
    }
    
    if (gameState == GameState.TITLE) {
      // プレイヤー参加処理
      for (int i = 0; i < playerKeys.length; i++) {
        if (k == playerKeys[i]) {
          playerJoined[i] = true;
        }
      }
      
      // スペースキーでゲーム開始
      if (k == ' ') {
        int joinedCount = 0;
        for (boolean joined : playerJoined) {
          if (joined) joinedCount++;
        }
        
        if (joinedCount >= 2) {
          startGame();
        }
      }
    } else if (gameState == GameState.GAME_OVER && k == 'r') {
      restart();
    } else if (gameState == GameState.PLAYING) {
      for (Earth earth : earths) {
        earth.handleKeyPressed(k);
      }
    }
  }
  
  void handleKeyReleased(char k) {
    k = Character.toLowerCase(k);
    
    if (gameState == GameState.PLAYING) {
      for (Earth earth : earths) {
        earth.handleKeyReleased(k);
      }
    }
  }
  
  void startGame() {
    gameState = GameState.PLAYING;
    earths.clear();
    
    // 参加したプレイヤーの地球を生成
    for (int i = 0; i < 4; i++) {
      if (playerJoined[i]) {
        earths.add(new Earth(300, i, playerKeys[i]));
      }
    }
  }
  
  void restart() {
    gameState = GameState.TITLE;
    winner = -1;
    earths.clear();
    mercury = new Mercury();
    venus = new Venus();
    particleManager = new ParticleManager();
    
    for (int i = 0; i < 4; i++) {
      playerJoined[i] = false;
    }
  }
}
