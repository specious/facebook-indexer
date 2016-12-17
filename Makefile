all: prepare wall

prepare:
	facebook-cli likes > likes.txt
	awk 'NR % 3 == 2' likes.txt > urls.txt

wall:
	./build-wall.sh urls.txt > index.html
	rm -f likes.txt urls.txt
	@echo Done! Open index.html in your browser.

clean:
	rm -rf images/
	rm -f likes.txt urls.txt index.html