# Linuxでたたいたコマンドとかいろいろ

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [1. yum (ヤム)](#1-yum-ヤム)
- [2. apt (アプト)](#2-apt-アプト)
- [3. rpm](#3-rpm)
- [4. pip (Pip Installs Packages (OR Python)) (ピップ)](#4-pip-pip-installs-packages-or-python-ピップ)

<!-- /code_chunk_output -->

## 1. yum (ヤム)

CentOSなどのRedHat系のディストリビューションで利用される
「パッケージ管理システム」で用いられるコマンド

インストールでは
yumは依存関係をもつほかのものも必要に応じてインストールしてくる。

インストール
`yum install [パッケージ名]`

sudoをつけて管理者権限で行わないと実行できないので実質こんな感じ
`sudo yum install [パッケージ名]`

途中でなんやかんや聞かれるやつをyesでこたえる
`sudo yum install -y [パッケージ名]`

アップデート
`sudo yum update [パッケージ名]`

python3 install
`yum -y install python3`

## 2. apt (アプト)

UbuntuなどのDebian系ディストリビューションで利用される
「パッケージ管理システム」で用いられるコマンド

## 3. rpm

インストールにもちいるが
rpmは指定されたものしかインストールしない

## 4. pip (Pip Installs Packages (OR Python)) (ピップ)

pythonのパッケージ管理システム。
インストールしたpythonの中に入っている。

pythonにあらかじめ定義されているパッケージのインストールやアンインストールのためのコマンド。

又、それらパッケージを管理する機構を
PyPI(Python Package Index)(ぱいぱい)
というらしい。

パッケージのインストール
`pip install [パッケージ名]`

インストール済みパッケージ名/バージョン一覧
`pip list`

pipのバージョン情報を表示
`pip -V`

アップグレード
`pip install -U [パッケージ名]`

pip help
`pipの主要コマンドとオプション一覧表示`
