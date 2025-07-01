# ShieldBadges makefile
# HTTPStatusCode badge make

## Root targets --------------------- ##
httpstatus: httpstatus.zip

## Prepare -------------------------- ##
generator/httpstatus.mk: ../httpstatus.json .preflight-check .generator.pre
## メタデータ JSON から generator/httpstatus.mk を生成する
	jq -rf .scripts/generate-from-metadata.jq ../httpstatus.json > generator/httpstatus.mk

include generator/httpstatus.mk

.httpstatus.pre: .pre generator/httpstatus.mk
	mkdir -p httpstatus.svg httpstatus.png
	touch .httpstatus.pre

## ---------------------------------- ##
httpstatus.svg: ${httpstatus.svg} generator/httpstatus.mk
httpstatus.png: ${httpstatus.png} generator/httpstatus.mk
httpstatus.clean: ; -rm -rf httpstatus.zip httpstatus.svg httpstatus.png .httpstatus.pre

httpstatus.zip: ${httpstatus.png} httpstatus.png/meta.json
	cd httpstatus.png && zip ../httpstatus.zip meta.json ./*.png

httpstatus.png/meta.json: ../httpstatus.json .httpstatus.pre
	jq -cf .scripts/build-meta.jq ../httpstatus.json > httpstatus.png/meta.json

## ---------------------------------- ##
.PHONY: httpstatus httpstatus.svg httpstatus.png httpstatus.clean
