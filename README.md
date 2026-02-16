# Raycast Script Collection

Raycast用のユーティリティスクリプト集です。

## スクリプト一覧

### 📍 get_globalIP.sh

グローバルIPアドレスを取得してクリップボードにコピーします。

**機能:**
- 複数の外部サービス（ipinfo.io、ifconfig.me、icanhazip.com）から自動的にIPアドレスを取得
- フォールバック機能により、サービスが利用できない場合でも次のサービスを試行
- 取得したIPアドレスを自動的にクリップボードにコピー

**使い方:**
Raycastから `get_globalIP` を実行

### 📸 upload-to-gyazo.sh

クリップボードにある画像をGyazoにアップロードし、URLをクリップボードにコピーします。

**機能:**
- クリップボードの画像を自動検出
- Gyazo APIを使用してアップロード
- アップロードされた画像のURLをクリップボードにコピー
- 1Passwordとの統合サポート（オプション）

**使い方:**
1. 画像をクリップボードにコピー（スクリーンショットなど）
2. Raycastから `Upload to Gyazo` を実行

**必要な設定:**
- `.env`ファイルに以下の環境変数を設定
  - `GYAZO_ACCESS_TOKEN`: GyazoのAPIアクセストークン
  - `GYAZO_1PASSWORD_PATH`: 1Passwordの参照パス（オプション、トークンを1Passwordに保存する場合）

### 🔧 load_env.sh

`.env`ファイルから環境変数を読み込むユーティリティスクリプトです。

**機能:**
- `.env`ファイルの読み込み
- コメント行と空行の自動スキップ
- 環境変数の自動エクスポート
- 引用符の自動処理

**使い方:**
他のスクリプトから `source "$SCRIPT_DIR/load_env.sh"` で読み込む

## セットアップ

### 1. リポジトリのクローン

```bash
git clone <repository-url>
cd raycast_script
```

### 2. 環境変数の設定

`.env.sample`から`.env`ファイルを作成し、必要な環境変数を設定

### 3. Raycastへの登録

1. Raycastの設定を開く
2. Extensions > Script Commands を選択
3. このリポジトリのディレクトリを追加

## 必要な環境

- macOS
- [Raycast](https://www.raycast.com/)
- curl
- osascript（macOSに標準搭載）
- 1Password CLI（オプション、1Password統合を使用する場合）