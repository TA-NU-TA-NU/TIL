# SpringInitializrってすごいね

SpringBootの便利なしくみの一つ。
SpringInitializr について。

- [SpringInitializrってすごいね](#springinitializrってすごいね)
  - [1.1. 結論](#11-結論)
  - [1.2. 詳細](#12-詳細)
  - [1.3. 課題](#13-課題)
  - [1.4. 参考資料](#14-参考資料)

## 1.1. 結論

SpringInitializrはprojectのひな形作成のためのWebサービス。

[spring initializr](https://start.spring.io/)

（自分はずっと各IDEが提供している便利機能だと思ってた…
それでもprojectは構築できるけど本質ではないから理解としてはダメ）

これを利用することで、素早く簡単に必要最低限の設定が施されたひな形を
zipやコピペ可能な状態での取得ができる。

## 1.2. 詳細

1. 上記リンクにアクセス
2. Project選択（Maven Or Gradle）
3. Language選択
4. Spring Boot のバージョン選択
5. Projet Metadata にpackage名やJava のバージョンなどを記入・選択
6. Dependenciesを選択する ADD DEPENDENCIES...から選択可能
7. EXPLORE押下で最終的なディレクトリ構造を展開して確認可能（ここで必要な部分をコピペしてきてもOK）
8. GENERATE押下でzipとしてダウンロード
9. 開発環境に展開

## 1.3. 課題・感想

今までSpringを体系的に理解してこなかったのでこういう存在にも疎かった…
物事の体系的理解や横断的な把握は理解の指標としてとても大切だと感じた

資料を頭から理解しようとするのはつらいし遠回りだったりするけど
全体を把握したりするためにも一度体系だった資料に触れるべきだと悟った。

## 1.4. 参考資料

- Spring徹底入門
