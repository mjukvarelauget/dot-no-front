SRC_FOLDER = src
BUILD_FOLDER = build
TEST_SERVER_CALL = python3 -m http.server --bind localhost


build_from_node:
	npm i
	rm -rf $(BUILD_FOLDER)
	cp -r public $(BUILD_FOLDER)
	elm make $(SRC_FOLDER)/Main.elm --optimize --output=$(BUILD_FOLDER)/main.js

deploy: build_from_node
	cd build/ && $(TEST_SERVER_CALL)
