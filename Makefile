ELMINSTALL = "node_modules/elm/bin"
ELMVERSION = "0.19.1"

build: 	clean install compile
	echo "Building project"
	cp -r public build
	mv main.js build/main.js

compile: src/Main.elm
	$(ELMINSTALL)/elm make src/Main.elm --optimize --output=main.js

.PHONY: clean
clean:
	rm -rf build/

.PHONY: clear
clear: clean
	rm -rf node_modules/

.PHONY: install
install:
	./installElm.sh $(ELMINSTALL) $(ELMVERSION)
