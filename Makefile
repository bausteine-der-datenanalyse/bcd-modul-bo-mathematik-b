PDF_JOBS ?= 8
DECKTAPE_ARGS ?=

DECKTAPE_DIRS = lernpfad/r-folien/c

SNAPSHOT_DIRS = lernpfad/aufgaben/c \
                lernpfad/r-folien/c \
                lernpfad/statistik-folien/c/folien \
                lernpfad/statistik-skript

RENDER_TARGETS = render-r-folien \
                 render-r-folien-alle \
                 render-statistik-folien \
                 render-statistik-skript \
                 render-veranstaltung \
                 render-weitere-unterlagen

publish: render render-decktape

render: render-aufgaben $(RENDER_TARGETS)

# Aufgaben mit loi-moi (pre-render in lernpfad/aufgaben/_quarto.yml, Konfiguration in loimoi.yml)
render-aufgaben:
	quarto render lernpfad/aufgaben --quiet

$(RENDER_TARGETS): render-%:
	cd lernpfad/$* && ../../bausteine/bcd-bausteine-montieren/collect-content.R
	quarto render lernpfad/$* --quiet

render-decktape:
	for d in $(DECKTAPE_DIRS); do \
		find __output/$$d -maxdepth 1 -name '*.html' -print0; \
	done | \
		xargs -0 -P $(PDF_JOBS) -I {} \
			sh -c 'decktape reveal $(DECKTAPE_ARGS) -s 1050x700 -p 200 "$$1" "$${1%.html}.pdf"' _ {}

snapshot:
	rm -rf __snapshot
	for d in $(SNAPSHOT_DIRS); do \
		p=$${d#lernpfad/}; p=$${p%%/*}; \
		mkdir -p __snapshot/$$p; \
		cp __output/$$d/*.pdf __snapshot/$$p/; \
	done

diff-snapshot:
	rm -rf __snapshot-diff
	for d in $(SNAPSHOT_DIRS); do \
		p=$${d#lernpfad/}; p=$${p%%/*}; \
		for f in __snapshot/$$p/*.pdf; do \
			n=`basename "$$f"`; \
			if [ ! -f "__output/$$d/$$n" ]; then \
				echo "removed:   $$p/$$n"; \
			elif diff-pdf -s "$$f" "__output/$$d/$$n"; then \
				echo "same:      $$p/$$n"; \
			else \
				mkdir -p __snapshot-diff/$$p; \
				diff-pdf -m --output-diff="__snapshot-diff/$$p/$$n" "$$f" "__output/$$d/$$n"; \
				echo "different: $$p/$$n"; \
			fi; \
		done; \
		for f in __output/$$d/*.pdf; do \
			n=`basename "$$f"`; \
			[ -f "__snapshot/$$p/$$n" ] || echo "new:       $$p/$$n"; \
		done; \
	done

quick-publish:
	$(MAKE) render-statistik-skript & s=$$!; \
	$(MAKE) render-r-folien render-statistik-folien render-aufgaben render-decktape && wait $$s

quick-snapshot: quick-publish
	$(MAKE) snapshot

clean:
	rm -rf __output .quarto
	rm -rf lernpfad/aufgaben/c lernpfad/aufgaben/.quarto
	for f in $(RENDER_TARGETS:render-%=lernpfad/%); do \
		rm -rf $$f/c $$f/.quarto $$f/_bcd-setup.* $$f/*.bib $$f/bcd-style-notes.css \
			$$f/*_files $$f/index.html $$f/site_libs; \
	done

# Check the published pages from links.md and the links on them, with lychee (brew install lychee), also run on
# GitHub after deploying. All URLs from links.md (also PDF and Zip) via stdin, the HTML pages also as input
LINKS_URLS = grep -o 'https://bausteine-der-datenanalyse\.github\.io/[^[:space:]]*' links.md | sort -u

check-links:
	$(LINKS_URLS) | lychee --no-progress --max-retries 5 --retry-wait-time 10 - $$($(LINKS_URLS) | grep '\.html$$')

# Check the links in the Moodle course (URL activities and texts) through the web service, only locally: token in
# ~/.config/moodle/token (not in the repo), sent by POST. jq unescapes the JSON, links to Moodle itself are skipped
MOODLE = https://moodle.hs-bochum.de/webservice/rest/server.php
MOODLE_COURSE = 11679

check-moodle-links:
	curl -s "$(MOODLE)?moodlewsrestformat=json&wsfunction=core_course_get_contents&courseid=$(MOODLE_COURSE)" \
		--data-urlencode "wstoken=$$(tr -d '[:space:]' < ~/.config/moodle/token)" \
		| jq -r '.. | strings' \
		| lychee --no-progress --exclude 'moodle\.hs-bochum\.de' -

bootstrap:
	R -e "install.packages(\"remotes\", repos = \"https://cran.uni-muenster.de\"); remotes::install_deps(upgrade = \"always\")"

update-extension:
	for d in . bausteine/bcd-bausteine-statistik bausteine/bcd-bausteine-r; do \
		(cd $$d && quarto update matthiasbaitsch/quarto-tinh --no-prompt) || exit 1; \
	done
	quarto use brand matthiasbaitsch/hsbo-brand --force

update-from-github:
	git pull
	git submodule update --recursive --remote

commit:
	git add .
	git commit -m "WIP"
	git push

update-commit: update-from-github commit
