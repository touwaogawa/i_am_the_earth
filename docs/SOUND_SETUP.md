# サウンド機能のセットアップ方法

このゲームで音を鳴らすには、Processing の Sound ライブラリが必要です。

## 方法1: プロジェクトフォルダにSoundライブラリを含める（推奨）

他の人に配布する際に最も簡単な方法です。

### 手順:
1. Processing IDE を開く
2. メニューから `Sketch` → `Import Library...` → `Add Library...` を選択
3. "Sound" を検索してインストール
4. Soundライブラリのフォルダを見つける:
   - Windows: `C:\Users\[ユーザー名]\Documents\Processing\libraries\sound\`
   - macOS: `~/Documents/Processing/libraries/sound/`
   - Linux: `~/sketchbook/libraries/sound/`
5. `sound` フォルダ全体をプロジェクトの `code` フォルダにコピー:
   ```
   i_am_the_earth/
   ├── src/
   └── code/
       └── sound/
           └── library/
               ├── sound.jar
               └── ...
   ```

### 配布方法:
- プロジェクトフォルダ全体（`code` フォルダを含む）を zip にして配布
- 受け取った人は解凍して Processing で開くだけで動作します

## 方法2: 各自でSoundライブラリをインストール

シンプルですが、各自がインストールする必要があります。

### プロジェクト配布者側:
1. README に以下を記載:
   ```
   このプロジェクトを実行する前に:
   Processing IDE で Sketch → Import Library... → Add Library...
   から "Sound" ライブラリをインストールしてください。
   ```

### プロジェクト受取側:
1. Processing IDE を開く
2. `Sketch` → `Import Library...` → `Add Library...`
3. "Sound" を検索してインストール
4. Processing を再起動
5. プロジェクトを開いて実行

## サウンドファイルについて

現在、`src/Sounds/` フォルダには `explosion.mp3` のみが含まれています。
他のサウンドファイルを追加する場合:

1. 以下のファイル名で MP3 ファイルを `src/Sounds/` に配置:
   
   **効果音 (SE):**
   - `launch.mp3` - 月を発射したとき
   - `hit.mp3` - 何かに当たったとき
   - `explosion.mp3` - 爆発（既にあります）
   - `burn.mp3` - 太陽に近づくとき
   - `splash.mp3` - 水を獲得したとき
   - `gravity.mp3` - 重力効果
   - `join.mp3` - プレイヤーが参加したとき
   - `start.mp3` - ゲームスタートしたとき
   - `retry.mp3` - リトライボタンを押したとき
   - `grow.mp3` - 月が成長(チャージレベルアップ)したとき
   - `applause.mp3` - 勝利時の拍手喝采
   
   **BGM:**
   - `title_bgm.mp3` - タイトル画面BGM（ループ再生）
   - `battle_bgm.mp3` - バトル中のBGM（ループ再生）
   - `result_jingle.mp3` - リザルト画面のジングル（1回再生、拍手音と同時に鳴る）

2. ファイルがない場合でもエラーにならず、その音だけが鳴りません

3. BGMは画面遷移時に自動的に切り替わります

## トラブルシューティング

### "processing.sound does not exist" エラーが出る場合:
- Sound ライブラリがインストールされていません
- 方法1または方法2でインストールしてください

### 音が鳴らない場合:
1. コンソールに "Sound system initialized" が表示されているか確認
2. ゲーム中に `M` キーを押して Sound ON/OFF を確認
3. サウンドファイル（.mp3）が正しいフォルダに配置されているか確認
4. PC の音量設定を確認

### Soundライブラリの詳細:
- 公式ドキュメント: https://processing.org/reference/libraries/sound/
