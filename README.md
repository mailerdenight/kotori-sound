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

`ことりサウンド/Info.plist` には、本番用のAdMobアプリIDとバナー広告ユニットIDを設定済みです。
本番公開時は、AdMob管理画面で次を確認してください。

- `GADApplicationIdentifier`
- `AdMobProductionBannerAdUnitID`
- `SKAdNetworkItems`

`AdMobTestBannerAdUnitID` はGoogleのテスト用IDのまま残します。DebugビルドではテストID、Releaseビルドでは本番IDを使う切り替えになっています。
AdMobの本番IDはパスワードではありませんが、実際のAdMobアカウントとバンドルIDの紐付きを公開前に確認してください。

## App Store提出前

- App Store ConnectのプライバシーポリシーURLに、別リポジトリで公開しているGitHub Pagesのページを登録する
- App Privacyで、Google Mobile Ads SDKが扱うデータ（デバイスID、広告データ、製品インタラクション、診断・パフォーマンス情報など）を実際の設定に合わせて申告する
- アプリ内課金商品 `com.ac.kotorisounds.pro` をApp Store Connectで作成し、価格・審査情報を設定する
- TestFlightで同意画面、広告、購入、購入復元、音声再生を実機確認する
