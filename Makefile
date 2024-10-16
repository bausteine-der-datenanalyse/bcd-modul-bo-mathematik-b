clean:
	rm -rf _output aufgaben/c aufgaben/.quarto

update:
	git submodule update --recursive --remote
	git add .
	git commit -m "WIP"
	git push