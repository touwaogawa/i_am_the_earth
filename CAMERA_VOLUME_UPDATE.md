# 機能追加 - BGM音量調整とリザルト画面カメラ

## 実装日
2025年10月5日

## 追加・変更した機能

### ✅ 1. BGMの音量を調整

**変更内容:**
- すべてのBGM（タイトルBGM、バトルBGM、リザルトジングル）の音量を **30%** に設定しました
- `SoundFile.amp(0.3)` を使用して音量を制御

**変更理由:**
- BGMが大きすぎる場合、効果音が聞き取りにくくなる
- ゲーム体験を向上させるため、BGMを控えめに設定

**技術詳細:**
```java
titleBGM.amp(0.3);   // タイトルBGMの音量を30%に
battleBGM.amp(0.3);  // バトルBGMの音量を30%に
resultJingle.amp(0.3); // リザルトジングルの音量を30%に
```

### ✅ 2. リザルト画面で勝利者をズームアップ＆追従

**変更内容:**
- リザルト画面で勝利したプレイヤー（地球）を **2.5倍にズームアップ**
- カメラが勝利者の地球を **滑らかに追従**
- 勝利者の地球は公転し続ける（動きが見える）
- ドロー（引き分け）の場合は画面中央を表示

**動作の流れ:**
1. ゲームオーバーになると、カメラが勝利者に向かって移動開始
2. 滑らかに（補間を使って）ズームインしながら追従
3. 勝利者の地球が太陽の周りを公転し続けるのを追いかける
4. リトライすると、カメラがタイトル画面の位置にリセット

**技術詳細:**

#### カメラ変数の追加
```java
// 現在のカメラ位置とズーム
float cameraX, cameraY, cameraZoom;
// 目標のカメラ位置とズーム
float targetCameraX, targetCameraY, targetCameraZoom;
```

#### カメラの更新処理（updateGameOver）
```java
void updateGameOver() {
  if (winner >= 0 && earths.size() == 1) {
    Earth winnerEarth = earths.get(0);
    targetCameraX = winnerEarth.x;  // 勝利者のX座標
    targetCameraY = winnerEarth.y;  // 勝利者のY座標
    targetCameraZoom = 2.5;         // 2.5倍にズーム
    
    // 勝利者の地球も更新し続ける（公転）
    winnerEarth.update();
  }
  
  // カメラを滑らかに移動（イージング）
  cameraX += (targetCameraX - cameraX) * 0.05;
  cameraY += (targetCameraY - cameraY) * 0.05;
  cameraZoom += (targetCameraZoom - cameraZoom) * 0.05;
}
```

#### レンダリング処理
```java
void render() {
  // カメラ変換を適用
  translate(width / 2, height / 2);
  scale(cameraZoom);              // ズーム
  translate(-cameraX, -cameraY);  // カメラ位置
  
  renderGame(); // ゲーム画面を描画
  
  // UI（ゲームオーバー表示）はカメラ変換を解除
  translate(cameraX, cameraY);
  scale(1.0 / cameraZoom);
  translate(-width / 2, -height / 2);
  renderGameOver();
}
```

## 変更されたファイル

### 1. `src/SoundManager.pde`
- `playTitleBGM()`: 音量を0.3に設定してループ再生
- `playBattleBGM()`: 音量を0.3に設定してループ再生
- `playResultJingle()`: 音量を0.3に設定して1回再生

### 2. `src/Game.pde`
- カメラ変数を追加（6個）
- `Game()`コンストラクタ: カメラを初期化
- `update()`: ゲームオーバー状態の更新を追加
- `updateTitle()`: カメラをデフォルトにリセット
- `updateGameOver()`: **新規追加** - 勝利者を追従するカメラ処理
- `render()`: カメラ変換を適用
- `restart()`: カメラをリセット

## ビジュアル効果

### リザルト画面のカメラ動作

```
ゲームオーバー発生
    ↓
カメラが勝利者に向かって移動開始
    ↓
滑らかにズームイン（2.5倍）
    ↓
勝利者の地球を追従（地球は公転し続ける）
    ↓
「Player X Wins!」のテキスト表示（画面に固定）
    ↓
Rキーでリトライ → カメラリセット
```

### イージング（滑らかな動き）
カメラの移動には **イージング** を使用:
```java
cameraX += (targetCameraX - cameraX) * 0.05;
```
この式により、カメラは目標位置に向かって **徐々に減速しながら** 移動します。

## パラメータ調整

必要に応じて以下の値を調整できます:

### BGM音量
```java
// SoundManager.pde
titleBGM.amp(0.3);  // 0.0〜1.0の範囲で調整可能
```

### ズーム倍率
```java
// Game.pde の updateGameOver()
targetCameraZoom = 2.5;  // より大きくしたい場合は3.0など
```

### カメラの移動速度（イージングの速さ）
```java
// Game.pde の updateGameOver()
cameraX += (targetCameraX - cameraX) * 0.05;  // 0.05を大きくすると速く移動
```

## 動作確認ポイント

### BGM音量
- [x] タイトルBGMが控えめな音量で再生される
- [x] バトルBGMが控えめな音量で再生される
- [x] リザルトジングルが控えめな音量で再生される
- [x] 効果音が聞き取りやすくなっている

### リザルト画面カメラ
- [x] ゲームオーバー時にカメラが勝利者に向かって移動
- [x] 滑らかにズームインする
- [x] 勝利者の地球が公転し続ける
- [x] カメラが地球を追従する
- [x] 「Player X Wins!」のテキストが画面中央に固定表示される
- [x] ドロー時は画面中央を表示
- [x] リトライ時にカメラがリセットされる

## 今後の改善案

### BGM音量
- 設定画面でBGM音量を調整できるようにする
- 効果音の音量も個別に調整可能にする

### カメラ演出
- 勝利時にカメラが一回転する演出
- ズームインの速度を徐々に変化させる
- パーティクルエフェクトを勝利者の周りに追加
- 敗者の地球もズームアウトで表示（小さく）
