.PHONY: deps compile test

default: deps compile test

deps:
	scripts/dep.sh camspiers aniseed origin/feature/fix-autoload-in-module-macro

compile:
	rm -rf lua
	deps/aniseed/scripts/compile.sh

test:
	rm -rf test/lua
	deps/aniseed/scripts/test.sh
