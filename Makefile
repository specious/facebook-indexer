all: prepare build

check-deps:
	@command -v facebook-cli >/dev/null 2>&1 || \
		{ echo >&2 "Please install and configure facebook-cli >=1.5.0 before continuing"; \
			exit 1; }

prepare: check-deps
	facebook-cli likes > likes.txt
	awk 'NR % 3 == 2' likes.txt > urls.txt

build:
	./build-wall.sh urls.txt $(ICON_HEIGHT) > index.html
	@echo
	rm -f likes.txt urls.txt
	@echo Done! Open index.html in your browser.

clean:
	rm -rf images/
	rm -f likes.txt urls.txt index.html