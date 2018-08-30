docs:
	elm-make --docs=documentation.json

run-demo:
	cd demo && npm i && npm start

# Make the github page (demo)
build-demo:
	rm -rf docs/*
	NODE_ENV=production cd demo && npm run build

.PHONY: demo
