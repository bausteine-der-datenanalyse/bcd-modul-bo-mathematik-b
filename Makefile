PDF_JOBS ?= 4
DECKTAPE_ARGS ?=

# Ordner mit Folien (relativ zu _output), aus denen PDFs erzeugt werden
SLIDES_PDF_DIRS = lernpfad/r-folien/c

clean:
	rm -rf _output .quarto _bcd-setup.R
	for f in lernpfad/statistik-skript lernpfad/statistik-folien lernpfad/aufgaben lernpfad/r-folien lernpfad/r-folien-alle lernpfad/veranstaltung lernpfad/weitere-unterlagen; do \
		rm -rf $$f/c $$f/.quarto $$f/_bcd-setup.* $$f/*.bib $$f/bcd-style-notes.css $$f/*_files $$f/index.html $$f/site_libs; \
	done

bootstrap:
	R -e "install.packages(\"remotes\", repos = \"https://cran.uni-muenster.de\"); remotes::install_deps(upgrade = \"always\")"

update-from-github:
	git pull
	git submodule update --recursive --remote

prepare-render:
	cd lernpfad/r-folien-alle && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	cd lernpfad/statistik-skript && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	cd lernpfad/statistik-folien && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	cd lernpfad/r-folien && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	cd lernpfad/veranstaltung && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	cd lernpfad/aufgaben && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	cd lernpfad/weitere-unterlagen && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	# Eigene Quarto-Projekte (Books), finden Extension und Brand im Hauptordner nur über Symlinks
	for f in lernpfad/statistik-skript lernpfad/r-folien-alle; do \
		ln -sfn ../../_extensions $$f/_extensions; \
		ln -sfn ../../_brand.yml $$f/_brand.yml; \
	done

render-veranstaltung: prepare-render
	quarto render lernpfad/veranstaltung

render-r-folien: prepare-render
	quarto render lernpfad/r-folien

render-r-folien-alle: prepare-render
	quarto render lernpfad/r-folien-alle

render-slides-pdf:
	for d in $(SLIDES_PDF_DIRS); do \
		find _output/$$d -maxdepth 1 -name '*.html' -print0; \
	done | \
		xargs -0 -P $(PDF_JOBS) -I {} sh -c 'decktape reveal $(DECKTAPE_ARGS) -s 1050x700 -p 200 "$$1" "$${1%.html}.pdf"' _ {}

render-statistik-skript: prepare-render
	quarto render lernpfad/statistik-skript

render-statistik-folien: prepare-render
	quarto render lernpfad/statistik-folien

render-aufgaben: prepare-render
	quarto render lernpfad/aufgaben

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

render-weitere-unterlagen: prepare-render
	quarto render lernpfad/weitere-unterlagen

render: render-veranstaltung render-r-folien render-r-folien-alle render-statistik-skript render-statistik-folien render-aufgaben render-weitere-unterlagen

publish: render render-slides-pdf

update-extension:
	quarto update matthiasbaitsch/quarto-tinh --no-prompt

commit:
	git add .
	git commit -m "WIP"
	git push

update-commit: update-from-github commit
