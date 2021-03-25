SRC_FOLDER = src
BUILD_FOLDER = build

build_from_node:
	npm i
	rm -rf $(BUILD_FOLDER)
	cp -r public $(BUILD_FOLDER)
	elm make $(SRC_FOLDER)/Main.elm --optimize --output=$(BUILD_FOLDER)/main.js
