# ShieldBadges makefile

## Root targets --------------------- ##
all: brands
clean-all: clean generator.clean; -rm .pre .preflight-check
clean: generator.clean brands.clean
prepare: .pre;

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
	@echo "|* all (default)"
	@echo "|* clean"
	@echo "|* clean-all"
	@echo "|* prepare"
	@echo "|* help"
	@echo ""
	@echo "* Categories:"
	@echo "| {category}, {category}.clean, {category}.svg, and {category}.png respectively"
	@echo "|> brands"

## Sub makefiles -------------------- ##
include brands.mk

## ---------------------------------- ##
.PHONY: all clean-all clean prepare help
