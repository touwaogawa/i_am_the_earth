// I am the Earth - メインファイル
Game game;

void setup() {
  size(800, 800);
  SoundManager.init(this);
  game = new Game();
}

void draw() {
  game.update();
  game.render();
}

void keyPressed() {
  game.handleKeyPressed(key);
  //if(key == 's')
  //  save("screenshot.png");
}

void keyReleased() {
  game.handleKeyReleased(key);
}
