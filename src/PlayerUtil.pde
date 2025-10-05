// プレイヤー関連のユーティリティ関数
// Processing では静的メソッドはトップレベルに直接定義する
color getPlayerColor(int playerId) {
  // 直接色の値を定義（安全な方法）
  switch(playerId) {
    case 0: return #6496FF;   // P1 青
    case 1: return #FF6464;   // P2 赤
    case 2: return #64FF64;   // P3 緑
    case 3: return #FFFF64;   // P4 黄
    default: return #B4B4B4;  // デフォルト グレー
  }
}
