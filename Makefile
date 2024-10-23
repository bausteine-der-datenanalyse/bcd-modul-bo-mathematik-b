clean:
	rm -rf _output aufgaben/c aufgaben/.quarto  folien/.quarto folien-r/c folien-r/.quarto

update:
	git submodule update --recursive --remote
	git add .
	git commit -m "WIP"
	git push