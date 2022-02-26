# 1. pl/pgsqlでfunction定義をしてみる

pl/pgsqlでfunctionをつくってダミーデータ挿入を省力化したかったので色々調べてみたまとめ

- [1. pl/pgsqlでfunction定義をしてみる](#1-plpgsqlでfunction定義をしてみる)
  - [1.1. こんな動機](#11-こんな動機)
  - [1.2. 試行錯誤の流れ](#12-試行錯誤の流れ)
    - [1.2.1. ベースとなるINSERT文を生成する](#121-ベースとなるinsert文を生成する)
  - [1.3. 完成品](#13-完成品)
    - [1.3.1. 知りし事などいろいろ](#131-知りし事などいろいろ)
      - [1.3.1.1. CREATE OR REPLACE FUNCTION (引数) RETURN 戻り値](#1311-create-or-replace-function-引数-return-戻り値)
      - [1.3.1.2. AS $$~$$](#1312-as---)
      - [1.3.1.3. DECLARE](#1313-declare)
      - [1.3.1.4. BEGIN](#1314-begin)
        - [1.3.1.4.1. num1:=arg_records](#13141-num1arg_records)
        - [1.3.1.4.2. FOR a IN 1..num1 LOOP END LOOP](#13142-for-a-in-1num1-loop-end-loop)
      - [1.3.1.5. EXECUTE](#1315-execute)
      - [1.3.1.6. RETURN true](#1316-return-true)
      - [1.3.1.7. END](#1317-end)
      - [1.3.1.8. LANGUAGE plpgsql](#1318-language-plpgsql)
      - [1.3.1.9. DROP](#1319-drop)
      - [1.3.1.10. 実行する](#13110-実行する)
  - [1.4. 感想とか課題](#14-感想とか課題)

## 1.1. こんな動機

ダミーデータをINSERTがめんどくさい  

エクセルやマクロでしこしこ作るのもなんかなぁ

→ pgsqlでfunction作ってあげると必要に応じて呼び出すだけでよいので
それをライブラリ化したらワンライナーみたいに便利になりそう…！  

## 1.2. 試行錯誤の流れ

### 1.2.1. ベースとなるINSERT文を生成する

一先ず作成。  

```console
-- insert
INSERT INTO log (log_id, task_id, log_decl, log_real)
VALUES (
    (SELECT CASE WHEN 'L' ||  MAX(TO_NUMBER(SUBSTRING(log_id,2,255),'999999999'))+1 ISNULL THEN 'L1'
            ELSE  'L' ||  MAX(TO_NUMBER(SUBSTRING(log_id,2,255),'999999999'))+1 END
            FROM log),
    'T2',
    3,
    3
  );
```  

ほんでもってこれについて、  
任意の回数、任意のtask_id, log_decl, log_realを指定して複数回INSERTしたい。
この時、このSQL文は1クエリにつき、1つの’LXXX’というルールのlog_idを払いだしてくれる。  

ここで、  
’LXXX’～’LXXX+100’なクエリを作りたいと考えたら、
このクエリがその時の最大値＋１の番号を払いだそうとするため
1クエリ1コミットで100回分回さないといけない。  
  
つまりあるテーブルの状態から100行同時生成するのではなく
ループで100回実施する形にしなければならない  

そこで、こいつを関数化する。pl/pgsqlはこういうニーズに対応するのが得意らしい。

## 1.3. 完成品

```console

CREATE OR REPLACE FUNCTION func_addlogs(arg_records int, arg_taskid VARCHAR(255) ,arg_decl int , arg_real int) RETURNS bool
AS $$
    DECLARE
        num1 int;
    BEGIN
        num1:=arg_records;
        FOR a IN 1..num1 LOOP
            EXECUTE
                'INSERT INTO log (log_id, task_id, log_decl, log_real)
                VALUES (
                    (SELECT CASE WHEN ''L'' ||  MAX(TO_NUMBER(SUBSTRING(log_id,2,255),''999999999''))+1 ISNULL THEN ''L1''
                            ELSE  ''L'' ||  MAX(TO_NUMBER(SUBSTRING(log_id,2,255),''999999999''))+1 END
                            FROM log),''' ||
                    arg_taskid ||
                    ''',' ||
                    arg_decl ||
                    ',' ||
                    arg_real ||
                 ');'
            ;
        END LOOP;
        RETURN true;
    END;
$$ LANGUAGE plpgsql;

```

### 1.3.1. 知りし事などいろいろ  

#### 1.3.1.1. CREATE OR REPLACE FUNCTION (引数) RETURN 戻り値  

CREATE OR REPLACE FUNCTION で新たな関数の定義か更新が可能。
javaの様にシグネチャで判別されるので、関数名が同じでも引数の型、戻り値の型の異なる関数は別もの扱いらしい  
  
そこら辺を変えたい場合はDROPして再度宣言しなおす必要がある。

RETURN 戻り値 でこの関数実行時の戻り値規定。  
今回は通ったかどうか知りたかったのでとりあえずbool返させた。  

#### 1.3.1.2. AS $$ ~ $$  

関数を定義する文字列定数。をここに置く。
$$ ~ $$はシングルクオーテーションを全体的にエスケープするため。
この中では普通に意識せず「’」と打ってよくなる。
  
#### 1.3.1.3. DECLARE  

変数定義をするところ。
今回はループ回数を制御するためのカウンタ変数の上限値の役割として  
num1 int;  
を用意した。  
  
#### 1.3.1.4. BEGIN

処理を記述するところ

今回の目的は  
用意したクエリに制御構造を与えて便利に使いまわす  
というようにも言い換えられると思う  

ここは、その制御を与える場面。

##### 1.3.1.4.1. num1:=arg_records

変数定義。与えられた引数はarg_recordsの様に呼び出せる。

定義時には:=を使う、すうがくみたい。（小並感）
  
##### 1.3.1.4.2. FOR a IN 1..num1 LOOP END LOOP  

いわゆるFOR文。1~num1までループさせる。  

#### 1.3.1.5. EXECUTE  

ここに記述したsqlを実行する
ここでは文字列として定義されるので、与えた引数を適用させるために
一度切って || で文字列結合する。

#### 1.3.1.6. RETURN true

返り値があればここに  

#### 1.3.1.7. END

おわり

#### 1.3.1.8. LANGUAGE plpgsql  

この関数を実装している言語をここに記述する  

#### 1.3.1.9. DROP

この関数がいらなくなった時や定義しなおしたくなったときに使った

```console
    --function DROP
    DROP FUNCTION func_addlogs(int,VARCHAR(255),int,int);
```

DROP FUNCTION 関数名(引数…)

#### 1.3.1.10. 実行する

こんな感じで実行

```console
    SELECT func_addlogs(100,'T2',2,2);
```

## 1.4. 感想とか課題  

初めて触れたけどもデータベースに対して検証したいときとか  
今回みたいなダミーデータの挿入とかを行いたい時に  
さらっとかけるといいなぁと感じた  
