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
	cd folien-r-alle && ../bausteine/bcd-bausteine-montieren/collect-content.R
	quarto render folien
	quarto render folien-r
	quarto render folien-r-alle
	quarto render aufgaben

commit:
	git add .
	git commit -m "WIP"
	git push

update-commit: update commit
