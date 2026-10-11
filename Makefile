PDF_JOBS ?= 4
DECKTAPE_ARGS ?=

# Ordner mit Folien (relativ zu _output), aus denen PDFs erzeugt werden
SLIDES_PDF_DIRS = veranstaltung/c r-folien/c

clean:
	rm -rf _output
	for f in lernpfad/statistik-skript lernpfad/aufgaben lernpfad/r-folien lernpfad/r-folien-alle lernpfad/veranstaltung weitere-unterlagen; do \
		rm -rf $$f/c $$f/.quarto $$f/_bcd-setup.* $$f/*.bib $$f/bcd-style-notes.css $$f/*_files $$f/index.html; \
	done

bootstrap:
	R -e "install.packages(\"remotes\", repos = \"https://cran.uni-muenster.de\"); remotes::install_deps(upgrade = \"always\")"

update-from-github:
	git pull
	git submodule update --recursive --remote

prepare-render:
	cd lernpfad/r-folien-alle && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	cd lernpfad/statistik-skript && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	cd lernpfad/r-folien && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	cd lernpfad/veranstaltung && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	cd lernpfad/aufgaben && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	cd weitere-unterlagen && ../bausteine/bcd-bausteine-montieren/collect-content.R

render-slides: prepare-render
	quarto render lernpfad/veranstaltung

render-slides-r: prepare-render
	quarto render lernpfad/r-folien

render-slides-r-all: prepare-render
	quarto render lernpfad/r-folien-alle -t html

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
	quarto render lernpfad/statistik-skript

render-assignments: prepare-render
	quarto render lernpfad/aufgaben

render-additional-materials: prepare-render
	quarto render weitere-unterlagen

render: render-slides render-slides-r render-slides-r-all render-notes render-assignments render-additional-materials

publish: render render-slides-pdf

update-extension:
	cd lernpfad/veranstaltung && quarto update matthiasbaitsch/quarto-hsbo-maba --no-prompt
	cd lernpfad/r-folien && quarto update matthiasbaitsch/quarto-hsbo-maba --no-prompt

commit:
	git add .
	git commit -m "WIP"
	git push

update-commit: update-from-github commit
