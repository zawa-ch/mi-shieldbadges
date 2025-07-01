# ShieldBadges makefile

## Root targets --------------------- ##
all: brands httpstatus
clean-all: clean generator.clean; -rm .pre .preflight-check; cmake --build build/ --target clean
clean: generator.clean brands.clean httpstatus.clean
prepare: .pre;
all-svg: brands.svg httpstatus.svg;
all-png: brands.png httpstatus.png;

## Prepare -------------------------- ##
## ビルドに使用するジェネレータなどの準備
.pre: generator/cshields-generator .preflight-check
## prepare は Phony target のため、事前準備を要求する場合はこちらを指定
	touch .pre

.generator.pre:
	mkdir -p generator
	touch .generator.pre

generator.clean:
	-rm -rf generator
	-rm .generator.pre

generator/cshields-generator: ../submodule/cshields/CMakeLists.txt .generator.pre
	cd ../submodule/cshields && cmake -B build -DCMAKE_BUILD_TYPE:STRING=Release
	cd ../submodule/cshields && cmake --build build --target cshields-generator
	cp -t generator ../submodule/cshields/build/cshields-generator

.preflight-check:
## このビルドスクリプトを走らせても大丈夫かどうかのチェック
	bash .scripts/preflight-check.sh

## Help ----------------------------- ##
help:
## この Makefile 自体のヘルプトピック
	@echo "Build ShieldBadges"
	@echo ""
	@echo "* Root targets:"
	@echo "|* all       - build all (default)"
	@echo "|* clean     - default clean"
	@echo "|* clean-all - clean completely"
	@echo "|* prepare   - prepare for build assets"
	@echo "|* all-svg   - build all svg assets"
	@echo "|* all-png   - build all png assets"
	@echo "|* help      - show this help"
	@echo ""
	@echo "* Categories:"
	@echo "| {category}, {category}.clean, {category}.svg, and {category}.png respectively"
	@echo "|> brands httpstatus"

## Sub makefiles -------------------- ##
include brands.mk
include httpstatus.mk

## ---------------------------------- ##
.PHONY: all clean-all clean prepare all-svg all-png help
