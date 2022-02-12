
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [1. dockerfile作成](#1-dockerfile作成)
- [2. コマンドをたたく](#2-コマンドをたたく)
  - [2.1. イメージ取得 ～ コンテナ作成](#21-イメージ取得-~-コンテナ作成)
  - [2.2. コマンドの実行 ⇔ dockerfile記述](#22-コマンドの実行-dockerfile記述)
  - [2.3. dockerfileの推敲](#23-dockerfileの推敲)

<!-- /code_chunk_output -->

# 1. dockerfile作成

大まかな指針
・手打ちでたたいたコマンドや操作をdockerfileに記述
・buildして意図した結果が得られることを確認
・記述内容をさらにまとめる。

# 2. コマンドをたたく

## 2.1. イメージ取得 ～ コンテナ作成

ベースとなるイメージを決める。

`docker pull`でイメージ取得可能。

pullしてきたイメージがdockerfileにおけるFROMになる。

例）centosを取得してポート指定で起動

`docker container run -it -d -p 9090:80 --name centos centos:latest`

`-it`
-i:interactive -t:ttyがくっついたもの
制御端末機能を付与する。

`-d`　（detach）
フォアグラウンドで動くとターミナルをつかまれてしまうため

つかまれてしまった場合は
 `Ctrl+P -> Ctrl+Q`
と続けて入力するとよい

逆にバックグラウンドのものをフォアグラウンドにしたい場合は
`container attach [コンテナ名]`

## 2.2. コマンドの実行 ⇔ dockerfile記述

コンテナ内に入る
`docker exec -it centos bash`

実行したコマンドをdockerfileに記述
この時はまだレイヤは意識せずとにかくメモをとる感覚で記述

意図したコンテナが作れるまであれやこれやする

## 2.3. dockerfileの推敲

RUN ～ のような命令文は極力ひとまとめにするとレイヤが減ってメモリの節約になる。

例:

```docker
RUN yum -y install python3 \
    nodejs npm \
    java-11-openjdk java-11-openjdk-devel \
&& npm install -g n \
…
```

（コマンドを書くにしてもベターな順序とかあるのかな…）

可能な限りまとめていく。

コマンドをまとめることでbuildの実効速度も改善する。
