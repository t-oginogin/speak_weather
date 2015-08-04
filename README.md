# 対話式お天気おしゃべりアプリ for Raspberry Pi

## 機能

キーワードを話すと、明日の天気の内容をしゃべります。

- 「天気」: 天気の内容
- 「気温」: 最高気温と今日との気温差
- 「傘」: 傘指数に応じた内容
- 「紫外線」: 紫外線指数の応じた内容

神戸市の天気を取ってくるようにしています。
speak_weather.rbのstartの引数でエリア情報を渡しています。

## 準備(Raspberry Pi)

- 無線LAN環境（天気を見に行くため）
- USBマイクを接続（音声入力のため）
- スピーカーをオーディオジャックに接続（音声出力のため）
- Ruby 2.2.2インストール（rbenv利用）
- mpg123インストール（音声再生のため）
- Julius（音声認識のため）

Raspberry Piでのマイク入力、スピーカー出力の設定は次の記事をご覧ください。

- [Raspberry Piで音声認識](http://qiita.com/t_oginogin/items/f0ba9d2eb622c05558f4)
- [Raspberry Piで音声認識（パフォーマンス改善）](http://qiita.com/t_oginogin/items/0634000e6713f9174b5f)

自動起動のために次の設定をします。

- Julius本体は/home/pi/julius-4.3.1/julius/juliusに配置。
- Juliusディクテーションは/home/pi/julius-kits/dictation-kit-v4.3.1-linux/に配置。
- config/weather.jconfを/home/pi/julius-kits/dictation-kit-v4.3.1-linux/に配置。
- config/weather.dicを/home/pi/julius-kits/dictation-kit-v4.3.1-linux/に配置。
- config/start_julius.shを/home/pi/julius-kits/dictation-kit-v4.3.1-linux/に配置。
- speak_weather全体を/home/pi/に配置。
- speak_weather直下でbundle install実行。
- initialize/setup_service.shを実行。

これで、Raspberry Piの電源を入れるだけで、お天気アプリが動作するようになります。
