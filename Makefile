docs:
	elm-make --docs=documentation.json

run-demo:
	cd example && npm start

# Make the github page (demo)
build-demo:
	rm -rf docs/*
	NODE_ENV=production cd example && npm run build

.PHONY: example
