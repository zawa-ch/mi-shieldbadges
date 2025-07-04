# ShieldBadges makefile
# License badge make

## ライセンスに対するカラーリングの決定方法
## * brightgreen ... パーミッシブライセンス
##   目的・形態に関わらず使用・改変・頒布する行為を認めているかが判断基準
## * orange ... コピーレフトライセンス
##   頒布にあたってパーミッシブライセンスの要件をライセンシーに要求しているかが判断基準
## * red ... プロプライエタリ
##   パーミッシブライセンスが要求しない制限を(それが現実的であるかにかかわらず)含むかが判断基準
##   (e.g. JSON は"善のために使うこと"をライセンスの要求に含んでいるため、プロプライエタリとして扱う)
## * 7cd958 ... パブリックドメイン
##   すべての著作権を放棄することが明記されている場合はこちら
##   本家 Shields ではattributionがないものと定義しているため、その違いに注意
##   (e.g. 0BSD は著作権の放棄自体は行っていないため、こちらではパーミッシブとして扱う)
## * lightgray ... どのカテゴリに属するかが不定、もしくは不明

## Root targets --------------------- ##
licenses: licenses.zip

## Prepare -------------------------- ##
generator/licenses.mk: ../licenses.json .preflight-check .generator.pre
## メタデータ JSON から generator/licenses.mk を生成する
	jq -rf .scripts/generate-from-metadata.jq ../licenses.json > generator/licenses.mk

include generator/licenses.mk

.licenses.pre: .pre generator/licenses.mk
	mkdir -p licenses.svg licenses.png
	touch .licenses.pre

## ---------------------------------- ##
licenses.svg: ${licenses.svg} generator/licenses.mk
licenses.png: ${licenses.png} generator/licenses.mk
licenses.clean: ; -rm -rf licenses.zip licenses.svg licenses.png .licenses.pre

licenses.zip: ${licenses.png} licenses.png/meta.json
	cd licenses.png && zip ../licenses.zip meta.json ./*.png

licenses.png/meta.json: ../licenses.json .licenses.pre
	jq -cf .scripts/build-meta.jq ../licenses.json > licenses.png/meta.json

## ---------------------------------- ##
.PHONY: licenses licenses.svg licenses.png licenses.clean
