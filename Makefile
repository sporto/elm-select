build:
	elm make src/Select.elm

docs:
	elm-make --docs=documentation.json

run-demo:
	cd demo && yarn && yarn start

# Make the github page (demo)
build-demo:
	rm -rf docs/*
	NODE_ENV=production cd demo && npm run build

.PHONY: demo
