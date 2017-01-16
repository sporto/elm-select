docs:
	elm-make --docs=documentation.json

example:
	cd example && npm start

# Make the github page
page:
	rm -rf docs/*
	NODE_ENV=production cd example && npm run build

.PHONY: example
