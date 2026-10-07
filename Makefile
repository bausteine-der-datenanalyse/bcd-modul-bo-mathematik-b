PDF_JOBS ?= 4
DECKTAPE_ARGS ?=

# Ordner mit Folien (relativ zu _output), aus denen PDFs erzeugt werden
SLIDES_PDF_DIRS = folien folien-r/c

clean:
	rm -rf _output
	for f in lernpfad/skript lernpfad/aufgaben lernpfad/folien-r lernpfad/folien-r-alle weitere-unterlagen; do \
		rm -rf $$f/c $$f/.quarto $$f/_bcd-setup.* $$f/*.bib $$f/bcd-style-notes.css $$f/*_files $$f/index.html; \
	done

bootstrap:
	R -e "install.packages(\"remotes\", repos = \"https://cran.uni-muenster.de\"); remotes::install_deps(upgrade = \"always\")"

update-from-github:
	git pull
	git submodule update --recursive --remote

prepare-render:
	cd lernpfad/folien-r-alle && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	cd lernpfad/skript && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	cd lernpfad/folien-r && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	cd lernpfad/aufgaben && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	cd weitere-unterlagen && ../bausteine/bcd-bausteine-montieren/collect-content.R

render-slides:
	quarto render lernpfad/folien

render-slides-r: prepare-render
	quarto render lernpfad/folien-r

render-slides-r-all: prepare-render
	quarto render lernpfad/folien-r-alle -t html

render-slides-pdf:
	for d in $(SLIDES_PDF_DIRS); do \
		find _output/$$d -maxdepth 1 -name '*.html' -print0; \
	done | \
		xargs -0 -P $(PDF_JOBS) -I {} sh -c 'decktape reveal $(DECKTAPE_ARGS) -s 1050x700 -p 200 "$$1" "$${1%.html}.pdf"' _ {}

save-slides-pdf:
	for d in $(SLIDES_PDF_DIRS); do \
		mkdir -p _vergleich/$$d; \
		cp _output/$$d/*.pdf _vergleich/$$d/; \
	done

diff-slides-pdf:
	for d in $(SLIDES_PDF_DIRS); do \
		mkdir -p _vergleich/diff/$$d; \
		for f in _vergleich/$$d/*.pdf; do \
			n=`basename "$$f"`; \
			if diff-pdf -s -m --output-diff="_vergleich/diff/$$d/$$n" "$$f" "_output/$$d/$$n"; then \
				echo "gleich:      $$d/$$n"; \
			else \
				echo "verschieden: $$d/$$n"; \
			fi; \
		done; \
	done

render-notes: prepare-render
	quarto render lernpfad/skript

render-assignments: prepare-render
	quarto render lernpfad/aufgaben

render-additional-materials: prepare-render
	quarto render weitere-unterlagen

render: render-slides render-slides-r render-slides-r-all render-notes render-assignments render-additional-materials

publish: render render-slides-pdf

update-extension:
	cd lernpfad/folien && quarto update matthiasbaitsch/quarto-hsbo-maba --no-prompt
	cd lernpfad/folien-r && quarto update matthiasbaitsch/quarto-hsbo-maba --no-prompt

commit:
	git add .
	git commit -m "WIP"
	git push

update-commit: update-from-github commit
