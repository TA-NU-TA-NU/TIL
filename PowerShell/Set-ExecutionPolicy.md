# 1. 一次的に実行ポリシーを変更する

PowerShellではでふぉで実行ポリシーには制限がなされている
規定はRestrictedポリシー.
変更には管理者権限が必要。

## 1.1 ポリシーいろいろ

1. Restricted
powershell初回起動時とかはこれ。
スクリプト実行時にエラーが出る厳格なモード

2. AllSigned
   デジタル署名のあるもののみ実行
   そうでないものは承認を求める

3. RemoteSigned
   基本はサイレント。リモートのスクリプトはAllSignedと同様。
   ブラウザやメール、メッセンジャーなどから取得してきたプログラムは実行するかどうか確認を求める。

4. Unrestricted
   どんなスクリプトも署名を求めない。スクリプトがインターネットからの取得物の場合は警告を発する。

## 2 変更する

`Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process`

-Scope オプションでは、この波及範囲を選べる。

- Process…このPowershellプロセス
- CurrentUser…現在のユーザーのみ
- LocalMachine…全ユーザー
  
## 3 現在のポリシーを確認したい

`Get-ExecutionPolicy`
