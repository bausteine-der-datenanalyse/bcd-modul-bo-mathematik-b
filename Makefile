clean:
	rm -rf _output
	rm -rf aufgaben/c aufgaben/.quarto
	rm -rf folien-r/c folien-r/.quarto
	rm -rf folien-r-alle/c folien-r-alle/.quarto
	rm -rf folien/.quarto

update:
	git submodule update --recursive --remote
	cp bausteine/bcd-bausteine-r/demo/folien-r/style.scss folien-r

render:
	quarto render aufgaben -t html
	quarto render folien-r -t revealjs

commit:
	git add .
	git commit -m "WIP"
	git push

update-commit: update commit
