// ==========================================
// CelestialBody.pde
// 継承: なし (抽象基底クラス)
// 説明: すべての天体の基底クラス
// 継承ツリー:
//   CelestialBody (このファイル)
//   ├─ Sun
//   └─ Planet
//      ├─ Earth
//      ├─ Mercury
//      └─ Venus
// ==========================================

// 天体の基底クラス
abstract class CelestialBody {
  protected float x, y;
  protected float radius;
  protected color bodyColor;
  protected String name;
  protected String nameKey; // Language key for localized name
  protected LanguageManager langManager;
  
  CelestialBody(float x, float y, float radius, color c, String name) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.bodyColor = c;
    this.name = name;
    this.nameKey = name; // Default to name as key
    this.langManager = null;
  }
  
  void setLanguageManager(LanguageManager lm) {
    this.langManager = lm;
  }
  
  String getLocalizedName() {
    if (langManager != null && nameKey != null) {
      return langManager.getText(nameKey);
    }
    return name;
  }
  
  abstract void update();
  abstract void render();
  
  float getX() { return x; }
  float getY() { return y; }
  float getRadius() { return radius; }
}
