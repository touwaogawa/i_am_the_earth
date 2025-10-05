// I am the Earth - メインファイル
Game game;

void setup() {
  size(800, 800);
  SoundManager.init(this);  // サウンドシステムの初期化
  game = new Game();
}

void draw() {
  game.update();
  game.render();
}

void keyPressed() {
  game.handleKeyPressed(key);
}

void keyReleased() {
  game.handleKeyReleased(key);
}
