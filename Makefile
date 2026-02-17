clean:
	rm -rf _output
	for f in skript aufgaben folien-r folien-r-alle weitere-unterlagen; do \
		rm -rf $$f/c $$f/.quarto $$f/_bcd-setup.* $$f/*.bib $$f/*_files $$f/index.html; \
	done

bootstrap:
	pip 
	R -e "install.packages(\"remotes\", repos = \"https://cran.uni-muenster.de\"); remotes::install_deps(upgrade = \"always\")" 

update-from-github:
	git pull
	git submodule update --recursive --remote
	cp bausteine/bcd-bausteine-r/bcd-style-slides.scss folien-r
	cp bausteine/bcd-bausteine-statistik/_bcd-setup.R .
	cp bausteine/bcd-bausteine-statistik/_bcd-setup.tex .

prepare-render:
	cd folien-r-alle && ../bausteine/bcd-bausteine-montieren/collect-content.R
	cd skript && ../bausteine/bcd-bausteine-montieren/collect-content.R
	cd folien-r && ../bausteine/bcd-bausteine-montieren/collect-content.R
	cd aufgaben && ../bausteine/bcd-bausteine-montieren/collect-content.R

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

update-commit: update-from-github commit
