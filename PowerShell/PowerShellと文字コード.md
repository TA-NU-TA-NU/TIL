- [1. PowerShellと文字コード](#1-powershellと文字コード)
  - [1.1. PowerShellで文字列を扱うときは文字コードに気を付ける](#11-powershellで文字列を扱うときは文字コードに気を付ける)
  - [1.2. 知らなかったはまりポイント](#12-知らなかったはまりポイント)
    - [1.2.1. PowerShellの内部のデフォ出力はUTF16LE](#121-powershellの内部のデフォ出力はutf16le)
    - [1.2.2. バイナリダンプの方法](#122-バイナリダンプの方法)
    - [1.2.3. どうしてこうなった](#123-どうしてこうなった)
    - [1.2.4. powershellv5での対処法](#124-powershellv5での対処法)
    - [1.2.5. PowerShell Core入れるのが良き](#125-powershell-core入れるのが良き)

# 1. PowerShellと文字コード

PowerShellは直感的に動かせて嫌いではないけれど
思いもよらぬところに地雷があったりでつらい。

自分が知識なさすぎなのでさらにきつい

## 1.1. PowerShellで文字列を扱うときは文字コードに気を付ける

PowerShellで内部で宣言した文字列を適当にテキストファイルとかにリダイレクトしたら
UTF8だと思ってたらUTF16LEだったりとなかなかこれが把握してないとはまりポイントだった。

色々調べて解ったこととかを自分なりにまとめておく。
でも文字コードの深いところは深淵すぎて限度があった…

## 1.2. 知らなかったはまりポイント
### 1.2.1. PowerShellの内部のデフォ出力はUTF16LE

先ず、
任意の位置にテキストファイルを用意して中に
"moji"と記載しておく。

この時、
テキストファイルの文字コードはUTF8であることを確認しておく。

ここではカレントディレクトリに"TXT.txt"を用意してみた。

次に、
こんな感じで文字列をPowerShell内部で生成してみる。

`$str = "moji"`

そしてこいつを以下コマンドでリダイレクトする。

`$str >> .\TXT.txt`

ほんでTXT.txtを開いてみる

`start .\TXT.txt`

こうなった

> moji  
> m o j i  
 
これには
UTF8と思ってたんで…

**大　草　原**

直接の理由はPowerShell内部ではデフォ出力がUTF16LEだかららしい。
特に指定せずにリダイレクトするとUTF16LEとして送られる。

### 1.2.2. バイナリダンプの方法
`[検証するもの] | Format-Hex`
って感じで可能

なので検証してみる。
`Get-Content .\TXT.txt | Format-Hex`
![実行結果](./img/Format-hex.png)

### 1.2.3. どうしてこうなった

順に流れを見ていくと、

**①テキストファイルにキーボード入力する**

こちらを参考に見ていく。
[ASCII - Wikipedia](https://ja.wikipedia.org/wiki/ASCII)

ASCII印字可能文字では、  
「m」= 0x6D  
「o」= 0x6F  
「j」= 0x6A  
「i」= 0x69  
と割り当てられている

**②UTF8で保存/UTF8でファイルを読み込む**
UTF8はASCIIと互換性がある。
ASCIIと同じコードは同じコードとなっている。
なのでこの時点では変わらず。

**③PowerShell内部で"moji"をつくる**
このタイミングでは
`$str = "moji"`
`$str | format-hex`
としてもかわらず。

![$str中身](./img/moji.png)

となるのが確認できる。

**④リダイレクトする**
ここが問題。

> 出力をファイルに書き込むコマンドレットの場合:
> 
> Out-File リダイレクト演算子と > を使用 >> して UTF-16LE を作成します。これは と とは特に異 Set-Content なります Add-Content 。
> （中略）
> 既存のファイルに追加するコマンドの場合:
> 
> Out-File -Append リダイレクト演算子 >> は、既存のターゲット ファイルのコンテンツのエンコードとの一致を試みない。 代わりに、Encoding パラメーターを使用しない限り、既定 のエンコード が使用されます。 コンテンツを追加するときに、ファイルの元のエンコードを使用する必要があります。
> 
> 原文ママ
> 出典　about_Character_Encoding  
> [https://docs.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_character_encoding?view=powershell-7.2](https://docs.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_character_encoding?view=powershell-7.2)

UTF16は基本16bitで一単位で以下のような対応となる。
[付録H　Unicode操作文字コード一覧（SORT EE）](http://itdoc.hitachi.co.jp/manuals/3020/30203N73A0/NTSO0551.HTM)
  
「m」= 0x6D -> 0x6D00  
「o」= 0x6F -> 0x6F00  
「j」= 0x6A -> 0x6A00  
「i」= 0x69 -> 0x6900  

なので、
こうなる。
![実行結果](./img/Format-hex.png)

**⑤これをUTF8のファイルでひらくと…**

16bit一単位ではなく、8bit一単位なので、二文字として解釈されてしまうため…
  
「m」= 0x6D -> 0x6D00 -> 0x6D 0x00  
「o」= 0x6F -> 0x6F00 -> 0x6F 0x00  
「j」= 0x6A -> 0x6A00 -> 0x6A 0x00  
「i」= 0x69 -> 0x6900 -> 0x69 0x00  

0x00　はUTF8ではNULLの制御文字らしい。

これを開くと一見すると空白に見えるみたい…。

### 1.2.4. powershellv5での対処法
`$OutputEncoding`をかえる。

これは、WindowsPowerShell自動変数の一つで自動的に使用・設定されている。

`$OutputEncoding`はパイプラインデータを外部プロセスに送るときに利用するエンコード形式。

これにたいして、
`$OutputEncoding=[System.Text.Encoding]::GetEncoding('utf-8')`
とするとutf-8になる。

ただし、
powershellを開きなおしてしまうと元に戻る。

なので、
プロファイルに入れて開く都度読み込ませるとかのひと工夫がいる。

### 1.2.5. PowerShell Core入れるのが良き
PowerShell Core を入れてあげるとデフォがBOMなしUTF8で扱ってくれるので今回の様にUTF8想定のファイルには特に意識せずリダイレクトしても問題ない。

