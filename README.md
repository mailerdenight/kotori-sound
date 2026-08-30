# ことりサウンド

App StoreへアップロードしたiPhoneアプリのXcodeプロジェクトです。

## 開き方

`ことりサウンド.xcodeproj` をXcodeで開きます。

## 残しているもの

- `ことりサウンド/` — 公開済みアプリのソースコードと組み込み画像
- `ことりサウンド.xcodeproj/` — Xcodeプロジェクト
- `SourceAssets/Illustrations/` — 組み込み画像の生成元
- `AppStoreAssets/` — App Store用アイコンの元画像
- `SourceAssets/Data/` — 鳥データと画像制作に使った資料

旧版の音源制作データ、ビルドキャッシュ、一時ファイルはプロジェクトから参照されていないため整理済みです。

## Google AdMob

現在はGoogle AdMobのテスト用アプリID・バナー広告ユニットIDで動作確認できる状態です。
本番公開前に、`ことりサウンド/Info.plist` の次の3項目をAdMob管理画面の値へ置き換えてください。

- `GADApplicationIdentifier`
- `AdMobProductionBannerAdUnitID`
- `AdMobTestBannerAdUnitID`

テスト用IDは開発・審査確認用として残し、本番広告では使用しないでください。
