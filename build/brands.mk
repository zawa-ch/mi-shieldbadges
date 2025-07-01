# ShieldBadges makefile
# Brands badge make

## Root targets --------------------- ##
brands: brands.zip

## Prepare -------------------------- ##
generator/brands.mk: ../submodule/simple-icons/data/simple-icons.json .preflight-check .generator.pre
## simple-icons のカタログから generator/brands.mk を生成する
	jq -rf .scripts/generate-from-simple-icons.jq ../submodule/simple-icons/data/simple-icons.json > generator/brands.mk

include generator/brands.mk

.brands.pre: .pre generator/brands.mk
	mkdir -p brands.svg brands.png
	touch .brands.pre

## ---------------------------------- ##
brands.svg: ${brands.svg} generator/brands.mk
brands.png: ${brands.png} generator/brands.mk
brands.clean: ; -rm -rf brands.zip brands.svg brands.png .brands.pre

brands.zip: ${brands.png} brands.png/meta.json
	cd brands.png && zip ../brands.zip meta.json ./*.png

brands.png/meta.json: ../submodule/simple-icons/data/simple-icons.json .brands.pre
	jq -cf .scripts/brands-meta.jq ../submodule/simple-icons/data/simple-icons.json > brands.png/meta.json

## ---------------------------------- ##
.PHONY: brands brands.svg brands.png brands.clean
