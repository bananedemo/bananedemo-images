# Unity アプリビルド VM イメージ (Windows Server 2019)

## 概要

[Azure Image Builder](https://docs.microsoft.com/ja-jp/azure/virtual-machines/image-builder-overview) と [Customazed CLI](https://github.com/yaegashi/customazed) を用いて Unity アプリビルド用の Windows VM イメージを作成します。

Customazed CLI の詳細については Qiita の次の記事を参照してください。

- [Azure Image Builder と Customazed CLI による簡単 VM イメージ構築](https://qiita.com/yaegashi/items/5216a9b37c2041b93a3a)

## 準備

Customazed CLI の実行前に次の準備を行ってください。

### customazed.json

[customazed.json](customazed.json) をお使いの環境にあわせて書き換えてください。

特に次の 3 項目は必ず設定する必要があります。

- `tenantId`
- `subscriptionId`
- `storageAccountName`

### setup.ps1

[scripts/setup.ps1](scripts/setup.ps1) は Unity アプリビルド VM のカスタマイズを行うスクリプトです。
Chocolatey を使って必要なソフトのインストールを行っています。必要に応じて修正してください。

### Unity.Licensing.Client

Unity.Licensing.Client アプリケーションをインストールしますので
Unity のサポートから Unity.Licensing.Client.win-x64-v1.8.0.zip のようなファイルを入手し
assets/UnityLicensingClient.zip という名前で配置してください。
このアプリケーションが不要な場合は、空またはダミーの ZIP ファイルでもかまいません。

### services-config.json

[assets/services-config.json](assets/services-config.json) は Unity ライセンスサーバ接続設定です。
SSH トンネル作成スクリプト [assets/tunnel.ps1](assets/tunnel.ps1) と組み合わせて使うことを想定しています。
環境に応じて書き換えてください。

## 実行

次の手順で実行してください。

```bash
# 認証
customazed login
# 機能登録
customazed feature register
# 関連リソース作成
customazed setup
# ビルド作成
customazed builder create
# ビルド開始 (タイムアウトでエラー終了します)
customazed builder run
# ビルド実行結果確認
customazed builder show-status
# VMイメージ作成結果確認
customazed builder show-runs
```

すべて完了すると CustomazedRG リソースグループの中に VM イメージと、それの共有イメージギャラリーのバージョンが作られます。
