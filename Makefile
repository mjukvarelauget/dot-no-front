build: clean compile
	echo "Building project"
	cp -r public build
	mv main.js build/main.js

compile: src/Main.elm
	elm make src/Main.elm --output=main.js

.PHONY: clean
clean:
	rm -rf build/
