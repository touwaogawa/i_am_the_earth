# フォルダ構造の提案

## 現在の構造
```
5/src/
  ├── main.pde
  ├── Game.pde
  ├── GameState.pde
  ├── CelestialBody.pde
  ├── Planet.pde
  ├── Sun.pde
  ├── Earth.pde
  ├── Moon.pde
  ├── Mercury.pde
  ├── Venus.pde
  ├── ParticleManager.pde
  ├── Particle.pde
  ├── SoundManager.pde
  ├── PlayerUtil.pde
  └── Sounds/
```

## 提案する構造（継承関係が分かりやすい）

### オプション1: クラス階層ごとにフォルダ分け
```
5/src/
  ├── main.pde
  ├── core/
  │   ├── Game.pde
  │   ├── GameState.pde
  │   └── PlayerUtil.pde
  ├── celestial/
  │   ├── base/
  │   │   ├── CelestialBody.pde  (抽象基底クラス)
  │   │   └── Planet.pde         (抽象惑星クラス)
  │   ├── planets/
  │   │   ├── Sun.pde            (CelestialBody継承)
  │   │   ├── Earth.pde          (Planet継承)
  │   │   ├── Mercury.pde        (Planet継承)
  │   │   └── Venus.pde          (Planet継承)
  │   └── Moon.pde
  ├── effects/
  │   ├── ParticleManager.pde
  │   └── Particle.pde
  ├── audio/
  │   └── SoundManager.pde
  └── Sounds/
```

### オプション2: 機能ごとにシンプルに分ける
```
5/src/
  ├── main.pde
  ├── game/
  │   ├── Game.pde
  │   ├── GameState.pde
  │   └── PlayerUtil.pde
  ├── entities/
  │   ├── CelestialBody.pde  (基底)
  │   ├── Planet.pde         (基底)
  │   ├── Sun.pde
  │   ├── Earth.pde
  │   ├── Moon.pde
  │   ├── Mercury.pde
  │   └── Venus.pde
  ├── effects/
  │   ├── ParticleManager.pde
  │   └── Particle.pde
  ├── audio/
  │   └── SoundManager.pde
  └── Sounds/
```

## ⚠️ Processing の制限について

**重要:** Processing では、`.pde` ファイルはスケッチフォルダ直下に配置する必要があります。

サブフォルダに `.pde` ファイルを配置すると、Processing がそれらを認識できず、
コンパイルエラーが発生します。

## 代替案: コメントで継承関係を明示

フォルダ構造を変更できないため、各ファイルの先頭に継承関係を明示するコメントを追加することを推奨します：

```java
// ==========================================
// CelestialBody.pde
// 継承: なし (基底クラス)
// 説明: すべての天体の抽象基底クラス
// ==========================================

// ==========================================
// Planet.pde
// 継承: CelestialBody
// 説明: 惑星の抽象クラス（軌道運動を実装）
// ==========================================

// ==========================================
// Sun.pde
// 継承: CelestialBody
// 説明: 太陽クラス（中心に固定、引力を持つ）
// ==========================================

// ==========================================
// Earth.pde
// 継承: Planet
// 説明: 地球クラス（プレイヤーが操作）
// ==========================================
```

この方法であれば、ファイルを開くだけで継承関係がすぐに分かります。

## 推奨: Mermaid図を README に追加

継承関係を視覚的に理解するため、Mermaid クラス図を README.md に追加することを推奨します。
（既に作成済み）
