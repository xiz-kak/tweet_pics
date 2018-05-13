## 概要
写真管理WEBアプリケーション（Twitterへの画像ツイート機能つき）

## バージョン情報
* Ruby: 2.4.2
* Rails: 5.1.5

## 開発環境作成手順
### 事前準備
https://apps.twitter.com/  
上記の管理画面からTwitterアプリを一つ作成のうえ、以下の値を取得してください。
* API Key
* API Secret

また、ご自身のAccess Tokenも作成し、以下の値を取得してください。
* Access Token
* Access Token Secret

### DB 構築
```
bundle exec rake db:create
```

### サーバー起動
Twitterアプリの各値を環境変数として指定して起動してください。
```
TW_API_KEY=<API Key> TW_API_SECRET=<API Secret> TW_ACCESS_TOKEN=<Access Token> TW_ACCESS_TOKEN_SECRET=<Access Token Secret> bundle exec rails s
```

## 参考にしたサイト
### 画像アップロード
https://cre8cre8.com/rails/upload-image.htm  
DB登録周り以外はこのサイトに記載の内容でほとんどカバーされておりました。

### Twitterアクセス
https://qiita.com/take2isk/items/95f44c107e32c892ac9b  
ヘッダー情報の生成の仕方について参考になりました。

https://syncer.jp/Web/API/Twitter/REST_API/#section-5  
Twitterへのファイルアップロード＋ツイート投稿について、参考になりました。

https://github.com/sferik/twitter  
Twitter gemのロジックを各所で参考にしました。

https://developer.twitter.com/en/docs  
最新かつ最も正確な情報源として参考にしました。

## 感想
gemなしでTwitter APIにアクセスをする、という点が最も苦労しました。  
特に署名作成周りはencodeなども絡んでくるため、問題解決に時間が取られた部分です。



