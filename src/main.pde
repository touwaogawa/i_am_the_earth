// I am the Earth - メインファイル
Game game;
PFont japaneseFont;

void setup() {
  size(800, 800);
  
  // Load Japanese font (using Processing's default font with createFont for Japanese support)
  japaneseFont = createFont("Yu Gothic UI", 32);
  textFont(japaneseFont);
  
  SoundManager.init(this);
  game = new Game();
}

void draw() {
  game.update();
  game.render();
}

void keyPressed() {
  game.handleKeyPressed(key);
  if(key == 's')
    save("screenshot.png");
}

void keyReleased() {
  game.handleKeyReleased(key);
}

void mousePressed() {
  game.handleMousePressed();
}
