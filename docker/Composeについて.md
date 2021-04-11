
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [1. Composeについて](#1-composeについて)
  - [1.1. docker-compose build](#11-docker-compose-build)
  - [1.2. docker-compose up](#12-docker-compose-up)
  - [1.3. docker-compose ps](#13-docker-compose-ps)
  - [1.4. docker-compose stop](#14-docker-compose-stop)
  - [1.5. docker-compose down](#15-docker-compose-down)

<!-- /code_chunk_output -->
# 1. Composeについて 
<br> 
## 1.1. docker-compose build 

docker-compose.yml で定義したイメージのビルドをおこなう 
特に指定しなければ[dir名_サービス名]が自動でつけられる 
`docker-compose build` のみではコンテナの作成起動はしない 
<br>

## 1.2. docker-compose up 
コンテナの展開 
`docker-compose up -d`でバックグラウンド実行
<br> 

## 1.3. docker-compose ps 
展開しているコンテナの実行状況確認 
`docker-container ls`もコンテナの確認としては同義
<br> 

## 1.4. docker-compose stop 
コンテナの停止 
再度利用するんならこれを使ってもいいけど 
コンテナの思想から鑑みて通常は破棄するものなので常用は非推奨 
残したいものは永続化してコンテナは使い捨てるようにする
<br> 

## 1.5. docker-compose down 
コンテナの破棄 
ネットワークは削除されるがボリュームは削除されない 
<br> 

