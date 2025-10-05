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
  
  // リザルト画面用カメラ
  float cameraX, cameraY, cameraZoom;
  float targetCameraX, targetCameraY, targetCameraZoom;
  
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
    
    // カメラの初期化
    cameraX = width / 2;
    cameraY = height / 2;
    cameraZoom = 1.0;
    targetCameraX = width / 2;
    targetCameraY = height / 2;
    targetCameraZoom = 1.0;
    
    // タイトルBGMを再生
    SoundManager.playTitleBGM();
  }
  
  void update() {
    if (gameState == GameState.TITLE) {
      updateTitle();
    } else if (gameState == GameState.PLAYING) {
      updatePlaying();
    } else if (gameState == GameState.GAME_OVER) {
      updateGameOver();
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
    // カメラをデフォルトにリセット
    targetCameraX = width / 2;
    targetCameraY = height / 2;
    targetCameraZoom = 1.0;
    cameraX = targetCameraX;
    cameraY = targetCameraY;
    cameraZoom = targetCameraZoom;
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
          
          // 発射済みの月が地球に当たった
          if (earth.moon.checkCollision(other)) {
            other.destroy(particleManager);
            earth.moon.reset();
            
            // ヒットストップと画面振動
            hitStopTimer = 10;
            shakeTimer = 20;
          }
          
          // 月同士の衝突判定（どちらも破壊）
          if (earth.moon.checkCollisionWithMoon(other.moon)) {
            earth.moon.reset();
            other.moon.reset();
            
            // 衝突地点でエフェクト
            float collisionX = (earth.moon.x + other.moon.x) / 2;
            float collisionY = (earth.moon.y + other.moon.y) / 2;
            particleManager.createExplosion(collisionX, collisionY, color(255, 200, 100), 15);
            SoundManager.playHit();
            
            // ヒットストップと画面振動
            hitStopTimer = 8;
            shakeTimer = 15;
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
      if (gameState != GameState.GAME_OVER) {
        // 初めてゲームオーバーになった時だけ効果音を鳴らす
        SoundManager.playApplause();
        SoundManager.playResultJingle();
      }
      gameState = GameState.GAME_OVER;
      winner = earths.get(0).playerId;
    } else if (earths.size() == 0) {
      if (gameState != GameState.GAME_OVER) {
        // 初めてゲームオーバーになった時だけ効果音を鳴らす
        SoundManager.playResultJingle();
      }
      gameState = GameState.GAME_OVER;
      winner = -1;
    }
  }
  
  void updateGameOver() {
    // 勝利したプレイヤーの地球を追従
    if (winner >= 0 && earths.size() == 1) {
      Earth winnerEarth = earths.get(0);
      targetCameraX = winnerEarth.x;
      targetCameraY = winnerEarth.y;
      targetCameraZoom = 2.5; // 2.5倍にズームアップ
      
      // 勝利者の地球も更新し続ける(公転し続ける)
      winnerEarth.update();
    } else {
      // ドローの場合は中央に戻す
      targetCameraX = width / 2;
      targetCameraY = height / 2;
      targetCameraZoom = 1.0;
    }
    
    // カメラを滑らかに移動
    cameraX += (targetCameraX - cameraX) * 0.05;
    cameraY += (targetCameraY - cameraY) * 0.05;
    cameraZoom += (targetCameraZoom - cameraZoom) * 0.05;
  }
  
  void render() {
    background(20);
    
    // 画面振動とカメラ変換を適用
    pushMatrix();
    translate(screenShakeX, screenShakeY);
    
    // カメラの中心を画面中央に設定
    translate(width / 2, height / 2);
    scale(cameraZoom);
    translate(-cameraX, -cameraY);
    
    if (gameState == GameState.TITLE) {
      // タイトル画面はカメラ変換をキャンセル
      translate(cameraX, cameraY);
      scale(1.0 / cameraZoom);
      translate(-width / 2, -height / 2);
      renderTitle();
    } else if (gameState == GameState.PLAYING || gameState == GameState.GAME_OVER) {
      renderGame();
      
      if (gameState == GameState.GAME_OVER) {
        // ゲームオーバー画面はカメラ変換をキャンセル
        translate(cameraX, cameraY);
        scale(1.0 / cameraZoom);
        translate(-width / 2, -height / 2);
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
    // text("Press key to join:", width/2, height/2 - 60);
    
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
      
      // SPACEキーについてのやかましい説明（吹き出し風）
      drawSpeechBubble(width/2 + 180, height - 200, 280, 80, 
        "This space is not the space\nin the universe, but the\nspace on the keyboard.");
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
    text("B: Toggle Sound", 10, 40);
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
          if (!playerJoined[i]) {
            playerJoined[i] = true;
            SoundManager.playJoin();
          }
        }
      }
      
      // スペースキーでゲーム開始
      if (k == ' ') {
        int joinedCount = 0;
        for (boolean joined : playerJoined) {
          if (joined) joinedCount++;
        }
        
        if (joinedCount >= 2) {
          SoundManager.playStart();
          startGame();
        }
      }
    } else if (gameState == GameState.GAME_OVER && k == 'r') {
      SoundManager.playRetry();
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
    
    // バトルBGMを再生
    SoundManager.playBattleBGM();
    
    // 参加したプレイヤーの数を数える
    ArrayList<Integer> joinedPlayerIds = new ArrayList<Integer>();
    for (int i = 0; i < 4; i++) {
      if (playerJoined[i]) {
        joinedPlayerIds.add(i);
      }
    }
    
    // 参加したプレイヤーの地球を等間隔で生成
    int playerCount = joinedPlayerIds.size();
    for (int i = 0; i < playerCount; i++) {
      int playerId = joinedPlayerIds.get(i);
      float angleOffset = TWO_PI * i / playerCount; // 等間隔の角度オフセット
      earths.add(new Earth(300, playerId, playerKeys[playerId], angleOffset));
    }
  }
  
  void restart() {
    gameState = GameState.TITLE;
    winner = -1;
    earths.clear();
    mercury = new Mercury();
    venus = new Venus();
    particleManager = new ParticleManager();
    
    // カメラをリセット
    cameraX = width / 2;
    cameraY = height / 2;
    cameraZoom = 1.0;
    targetCameraX = width / 2;
    targetCameraY = height / 2;
    targetCameraZoom = 1.0;
    
    // タイトルBGMを再生
    SoundManager.playTitleBGM();
    
    for (int i = 0; i < 4; i++) {
      playerJoined[i] = false;
    }
  }
  
  // 吹き出しを描画する補助関数
  void drawSpeechBubble(float x, float y, float w, float h, String message) {
    pushStyle();
    
    // 吹き出しの本体（角丸四角形）
    fill(255, 255, 255, 240);
    stroke(0);
    strokeWeight(2);
    rectMode(CENTER);
    rect(x, y, w, h, 10);
    
    // 吹き出しの三角形（しっぽ）
    noStroke();
    fill(255, 255, 255, 240);
    triangle(
      x - w/2 + 20, y + h/2,        // 吹き出しの底辺左側
      x - w/2, y + h/2,              // 吹き出しの底辺端
      x - w/2 - 30, y + h/2 + 30    // 指し示す先（左下）
    );
    
    // 三角形の縁取り
    stroke(0);
    strokeWeight(2);
    line(x - w/2 + 20, y + h/2, x - w/2 - 30, y + h/2 + 30);
    line(x - w/2, y + h/2, x - w/2 - 30, y + h/2 + 30);
    
    // テキスト描画
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(15);
    text(message, x, y);
    
    rectMode(CORNER); // デフォルトに戻す
    popStyle();
  }
}
