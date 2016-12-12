docs:
	elm-make --docs=documentation.json

example:
	rm -rf example/dist/*
	NODE_ENV=production cd example && npm run build

.PHONY: example
