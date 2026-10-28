PDF_JOBS ?= 4
DECKTAPE_ARGS ?=

# Ordner mit Folien (relativ zu __output), aus denen PDFs erzeugt werden
SLIDES_PDF_DIRS = lernpfad/r-folien/c

RENDER_TARGETS = render-veranstaltung render-r-folien render-r-folien-alle render-statistik-skript \
                 render-statistik-folien render-aufgaben render-weitere-unterlagen

render: $(RENDER_TARGETS)

$(RENDER_TARGETS): render-%:
	cd lernpfad/$* && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	quarto render lernpfad/$*

render-folien-pdf:
	for d in $(SLIDES_PDF_DIRS); do \
		find __output/$$d -maxdepth 1 -name '*.html' -print0; \
	done | \
		xargs -0 -P $(PDF_JOBS) -I {} sh -c 'decktape reveal $(DECKTAPE_ARGS) -s 1050x700 -p 200 "$$1" "$${1%.html}.pdf"' _ {}

save-folien-pdf:
	for d in $(SLIDES_PDF_DIRS); do \
		mkdir -p _vergleich/$$d; \
		cp __output/$$d/*.pdf _vergleich/$$d/; \
	done

diff-folien-pdf:
	for d in $(SLIDES_PDF_DIRS); do \
		mkdir -p _vergleich/diff/$$d; \
		for f in _vergleich/$$d/*.pdf; do \
			n=`basename "$$f"`; \
			if diff-pdf -s -m --output-diff="_vergleich/diff/$$d/$$n" "$$f" "__output/$$d/$$n"; then \
				echo "gleich:      $$d/$$n"; \
			else \
				echo "verschieden: $$d/$$n"; \
			fi; \
		done; \
	done

publish: render render-folien-pdf

clean:
	rm -rf __output .quarto
	for f in $(RENDER_TARGETS:render-%=lernpfad/%); do \
		rm -rf $$f/c $$f/.quarto $$f/_bcd-setup.* $$f/*.bib $$f/bcd-style-notes.css $$f/*_files $$f/index.html $$f/site_libs; \
	done

bootstrap:
	R -e "install.packages(\"remotes\", repos = \"https://cran.uni-muenster.de\"); remotes::install_deps(upgrade = \"always\")"

# Update extension tinh (_extensions/) and brand of Hochschule Bochum (_brand/)
update-extension:
	quarto update matthiasbaitsch/quarto-tinh --no-prompt
	quarto use brand matthiasbaitsch/hsbo-brand --force

update-from-github:
	git pull
	git submodule update --recursive --remote

commit:
	git add .
	git commit -m "WIP"
	git push

update-commit: update-from-github commit
