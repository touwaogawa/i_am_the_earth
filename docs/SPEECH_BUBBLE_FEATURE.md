# タイトル画面の改善 - SPACEキー説明吹き出し

## 実装日
2025年10月5日

## 追加した機能

### ✅ SPACEキーの説明吹き出し

**実装内容:**
タイトル画面の「Press SPACE to Start!」の横に、**吹き出し**で以下の説明を表示:

```
This space is not the space
in the universe, but the
space on the keyboard.
```

**意図:**
- ゲームタイトルが「I am the Earth」（宇宙がテーマ）なので、「SPACE」という単語が紛らわしい
- 「宇宙のスペース」ではなく「キーボードのスペースキー」であることを明確に説明
- ユーモラスで親切な注意書き

---

## 視覚的なデザイン

### 吹き出しの構造

```
     ┌─────────────────────────┐
     │ This space is not the   │
     │ space in the universe,  │
     │ but the space on the    │
     │ keyboard.               │
     └──┐                      │
        └──────────────────────┘
          ▼
    "Press SPACE to Start!"
```

### 吹き出しの特徴
- **白色背景** (透明度240/255) - やや透過で背景が見える
- **黒の縁取り** (2px) - はっきり見える
- **角丸四角形** (半径10px) - 柔らかい印象
- **三角形のしっぽ** - 「SPACE」の文字を指し示す
- **黒いテキスト** (12px) - 読みやすいサイズ

---

## 技術的実装

### 吹き出し描画関数

```java
void drawSpeechBubble(float x, float y, float w, float h, String message)
```

**パラメータ:**
- `x, y`: 吹き出しの中心座標
- `w, h`: 吹き出しの幅と高さ
- `message`: 表示するテキスト（改行 `\n` 対応）

**描画手順:**
1. 角丸四角形で吹き出しの本体を描画
2. 三角形で「しっぽ」を描画（指し示す方向）
3. 三角形の縁取りを描画（黒線）
4. テキストを中央揃えで描画

### 呼び出し部分

```java
// renderTitle() メソッド内
if (joinedCount >= 2) {
  fill(255, 255, 0);
  textSize(32);
  text("Press SPACE to Start!", width/2, height - 100);
  
  // SPACEキーについてのやかましい説明（吹き出し風）
  drawSpeechBubble(width/2 + 180, height - 100, 280, 80, 
    "This space is not the space\nin the universe, but the\nspace on the keyboard.");
}
```

**配置:**
- X座標: `width/2 + 180` - スタートテキストの右側
- Y座標: `height - 100` - スタートテキストと同じ高さ
- 幅: `280px`
- 高さ: `80px`

---

## 変更されたファイル

### 1. `src/Game.pde`

#### 追加したメソッド
- `drawSpeechBubble()` - 吹き出しを描画する補助関数（40行程度）

#### 変更したメソッド
- `renderTitle()` - スタート表示部分に吹き出しの呼び出しを追加

**変更箇所:**
```java
// 変更前
if (joinedCount >= 2) {
  fill(255, 255, 0);
  textSize(32);
  text("Press SPACE to Start!", width/2, height - 100);
}

// 変更後
if (joinedCount >= 2) {
  fill(255, 255, 0);
  textSize(32);
  text("Press SPACE to Start!", width/2, height - 100);
  
  // 説明吹き出しを追加
  drawSpeechBubble(width/2 + 180, height - 100, 280, 80, 
    "This space is not the space\nin the universe, but the\nspace on the keyboard.");
}
```

---

## デザインの詳細

### 色設定
```java
fill(255, 255, 255, 240);  // 白色、透明度240/255
stroke(0);                  // 黒い縁取り
strokeWeight(2);            // 縁の太さ2px
```

### 角丸四角形
```java
rectMode(CENTER);           // 中心座標で描画
rect(x, y, w, h, 10);      // 半径10pxの角丸
```

### 三角形のしっぽ
```java
triangle(
  x - w/2 + 20, y + h/2,        // 吹き出しの底辺左側
  x - w/2, y + h/2,              // 吹き出しの底辺端
  x - w/2 - 30, y + h/2 + 30    // 左下を指す
);
```

### テキスト設定
```java
fill(0);                    // 黒色
textAlign(CENTER, CENTER);  // 中央揃え
textSize(12);               // 小さめのフォント
```

---

## カスタマイズ方法

### 吹き出しの位置を変更

```java
// X座標を調整（右に移動したい場合）
drawSpeechBubble(width/2 + 200, height - 100, 280, 80, message);

// Y座標を調整（上に移動したい場合）
drawSpeechBubble(width/2 + 180, height - 120, 280, 80, message);
```

### 吹き出しのサイズを変更

```java
// より大きな吹き出し
drawSpeechBubble(width/2 + 180, height - 100, 320, 100, message);

// より小さな吹き出し
drawSpeechBubble(width/2 + 180, height - 100, 240, 60, message);
```

### テキストの内容を変更

```java
// より詳しい説明
drawSpeechBubble(width/2 + 180, height - 100, 300, 90, 
  "SPACE = Space Bar\n(the long key at the\nbottom of keyboard)");

// より簡潔な説明
drawSpeechBubble(width/2 + 180, height - 100, 200, 50, 
  "SPACE = keyboard key\n(not universe!)");
```

### テキストサイズを変更

```java
// drawSpeechBubble() 関数内
textSize(14);  // より大きく（デフォルトは12）
textSize(10);  // より小さく
```

### 吹き出しの色を変更

```java
// 背景色（例: 薄い黄色）
fill(255, 255, 200, 240);

// 縁取り色（例: 濃い灰色）
stroke(64);

// テキスト色（例: 濃い青）
fill(0, 0, 128);
```

---

## 表示条件

吹き出しは以下の条件で表示されます:

1. **タイトル画面**であること
2. **2人以上のプレイヤーが参加**していること
3. **「Press SPACE to Start!」が表示されている**こと

つまり、ゲーム開始可能な状態でのみ表示されます。

---

## ユーザー体験の向上

### Before（以前）
- 「Press SPACE to Start!」だけが表示
- 宇宙がテーマなので「SPACE」が紛らわしい可能性

### After（今回）
- ✨ 吹き出しで親切に説明
- ✨ ユーモアを交えた注意書き
- ✨ 初心者にも分かりやすい
- ✨ ゲームの世界観を壊さないデザイン

---

## 今後の拡張案

### 他の説明吹き出し
- [ ] 操作説明にも吹き出しを追加
- [ ] ヒント表示機能
- [ ] チュートリアル画面

### アニメーション
- [ ] 吹き出しが徐々に表示される
- [ ] 吹き出しが点滅する
- [ ] テキストがタイプライター風に表示

### インタラクション
- [ ] マウスホバーで詳細表示
- [ ] クリックで閉じる機能
- [ ] 複数の吹き出しを切り替え

---

## まとめ

タイトル画面に親切で面白い説明吹き出しを追加しました。
「宇宙のスペース」と「キーボードのスペースキー」を明確に区別することで、
ユーザーの混乱を防ぎ、ゲーム体験を向上させます。

**ポイント:**
- 親切な説明で初心者に優しい
- ユーモアのあるテキスト
- 視覚的に分かりやすい吹き出しデザイン
- ゲームの世界観を壊さない
