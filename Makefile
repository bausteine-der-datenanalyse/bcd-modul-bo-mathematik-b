clean:
	rm -rf _output
	rm -rf aufgaben/c aufgaben/.quarto
	rm -rf folien-r/c folien-r/.quarto
	rm -rf folien-r-alle/c folien-r-alle/.quarto
	rm -rf folien/.quarto

bootstrap:
	pip 
	R -e "install.packages(\"remotes\", repos = \"https://cran.uni-muenster.de\"); remotes::install_deps(upgrade = \"always\")" 

update:
	git submodule update --recursive --remote
	cp bausteine/bcd-bausteine-r/demo/folien-r/style.scss folien-r

prepare-render:
	cd folien-r-alle && ../bausteine/bcd-bausteine-montieren/collect-content.R
	cd skript && ../bausteine/bcd-bausteine-montieren/collect-content.R

render: prepare-render
	quarto render folien
	quarto render folien-r
	quarto render folien-r-alle
	quarto render skript
	quarto render aufgaben

commit:
	git add .
	git commit -m "WIP"
	git push

update-commit: update commit
