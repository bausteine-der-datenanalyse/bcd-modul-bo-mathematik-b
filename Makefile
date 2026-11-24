PDF_JOBS ?= 8
DECKTAPE_ARGS ?=

DECKTAPE_DIRS = lernpfad/r-folien/c

# Aufgaben: one folder per sheet (loi-moi), those with PDFs in __output
SNAPSHOT_DIRS = $(sort $(patsubst __output/%/,%,$(dir $(wildcard __output/lernpfad/aufgaben/c/*/*.pdf)))) \
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

# Own project, loi-moi prepares c/ from bausteine/*/*/aufgaben as pre-render
render-aufgaben:
	quarto render lernpfad/aufgaben

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

# Check the published pages from the link page of loi-moi (written by render-aufgaben) and the links on them, with
# lychee (brew install lychee), also run on GitHub after deploying
check-links:
	grep -o 'https://bausteine-der-datenanalyse\.github\.io/[^"<]*\.html' lernpfad/links-site.html | sort -u \
		| xargs lychee --no-progress --max-retries 5 --retry-wait-time 10

# Check the links in the Moodle course (URL activities and texts) through the web service, only locally: token in
# ~/.config/moodle/token (not in the repo), sent by POST. jq unescapes the JSON, links to Moodle itself are skipped
MOODLE = https://moodle.hs-bochum.de/webservice/rest/server.php
MOODLE_COURSE = 11679
MOODLE_CONTENTS = curl -s "$(MOODLE)?moodlewsrestformat=json&wsfunction=core_course_get_contents&courseid=$(MOODLE_COURSE)" \
	--data-urlencode "wstoken=$$(tr -d '[:space:]' < ~/.config/moodle/token)"

# Each broken link with section, activity and the link to edit the activity
MOODLE_REPORT = "\(.errors) broken of \(.unique) links", (.error_map[][] | . as $$error \
	| "\n\(.status.code // .status.text) \(.url)", ($$contents[0][] | .name as $$section | .modules[] \
	| select(any(.. | strings; contains($$error.url))) \
	| "  \($$section) → \(.name)\n  https://moodle.hs-bochum.de/course/modedit.php?update=\(.id)"))

check-moodle-links:
	@contents=$$(mktemp); result=$$(mktemp); \
	$(MOODLE_CONTENTS) > $$contents; \
	jq -r '.. | strings' $$contents | lychee --no-progress --format json --exclude 'moodle\.hs-bochum\.de' - > $$result; \
	status=$$?; \
	jq -r --slurpfile contents $$contents '$(MOODLE_REPORT)' $$result; \
	rm $$contents $$result; \
	exit $$status

bootstrap:
	R -e "install.packages(\"remotes\", repos = \"https://cran.uni-muenster.de\"); remotes::install_deps(upgrade = \"always\")"

# Update extensions tinh (also in the submodules statistik and r) and loi-moi (_extensions/) and brand of Hochschule
# Bochum (_brand/)
update-extension:
	for d in . bausteine/bcd-bausteine-statistik bausteine/bcd-bausteine-r; do \
		(cd $$d && quarto update matthiasbaitsch/quarto-tinh --no-prompt) || exit 1; \
	done
	quarto update matthiasbaitsch/quarto-loi-moi --no-prompt
	quarto use brand matthiasbaitsch/hsbo-brand --force

update-from-github:
	git pull
	git submodule update --recursive --remote

commit:
	git add .
	git commit -m "WIP"
	git push

update-commit: update-from-github commit

clean:
	rm -rf __output .quarto
	rm -rf lernpfad/aufgaben/c lernpfad/aufgaben/.quarto
	for f in $(RENDER_TARGETS:render-%=lernpfad/%); do \
		rm -rf $$f/c $$f/.quarto $$f/_bcd-setup.* $$f/*.bib $$f/bcd-style-notes.css \
			$$f/*_files $$f/index.html $$f/site_libs; \
	done
