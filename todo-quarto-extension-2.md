# TODO: Neutrale Quarto-Extension `tinh` statt `hsbo-maba`

Ziel: Bausteine-Repos und Lernpfad verwenden dasselbe Format. In den Bausteinen soll die HSBO aber nicht
auftauchen. Deshalb wandert `hsbo-maba` ohne die HSBO-spezifischen Dinge in eine neue, neutrale Extension. Was
HSBO bzw. BCD ausmacht (Logo, Farben, ggf. Name und Fußzeile), steht in einer `_brand.yml` je Projekt.

## Entscheidungen

- Eine neue, neutrale Extension enthält alles aus `hsbo-maba`, was nicht HSBO-spezifisch ist (Layout, Formate,
  Klassen wie `.up*`/`.down*`, `.framed`, `.raw`), dazu die Typst-Sachen:
  - Folien als PDF mit Typst/touying (bisher `quarto-touying-typst` mit Theme `clean` in
    `bcd-bausteine-statistik/_extensions/`)
  - Befehle aus `bcd-bausteine-statistik/_bcd-setup.typ` (`neuerbegriff`, `ja`, `nein`, `downN`)
  - später ggf. ein Typst-Format für das Skript
- Keine Logos und festen Farben in der Extension, alles über die Brand.
- `_brand.yml` je Projekt: BCD-Brand in `bcd-bausteine-statistik` und `bcd-bausteine-r`, HSBO-Brand in den
  Projekten unter `lernpfad/` (und in Informatik). Da `collect-content.R` die Bausteine nach `c/` im Lernpfad
  kopiert, gilt dort automatisch die HSBO-Brand.
- `hsbo-maba` fällt weg, am Ende wird das Repo gelöscht. Alle Projekte (auch Informatik) stellen um.
- Formate bauen immer auf einem Quarto-Grundformat auf und heißen `tinh-<zweck>-<grundformat>`, der Zweck auf Englisch (`slides`, `notes`, `assignments`). Je Zweck eine
  Extension im Repo `quarto-tinh` (Ordner unter `_extensions/`), jede mit mehreren Grundformaten:

  | Extension       | Formate                                                       | wofür                                    |
  |-----------------|---------------------------------------------------------------|------------------------------------------|
  | `tinh-slides`   | `tinh-slides-revealjs`, `tinh-slides-typst`                    | revealjs: Folien, bei denen Code wichtig ist (R, Einführung, Informatik); typst: Folien mit viel Mathematik, nur PDF (Statistik) |
  | `tinh-notes`   | `tinh-notes-html`, `tinh-notes-pdf`, später `tinh-notes-typst` | Skript                                |
  | `tinh-assignments` | `tinh-assignments-html`, `tinh-assignments-pdf`, später `tinh-assignments-typst` | Aufgaben- und Lösungsblätter      |

- `tinh-notes-pdf` und `tinh-assignments-pdf` (LaTeX) übernehmen `_bcd-setup.tex`, `latex-environment` und die
  Liste `commands`, `tinh-…-html` übernimmt `bcd-style-notes.css`. Damit entfällt das Kopieren dieser Dateien per
  `content.yml` und die `commands`-Listen in den `_quarto.yml`.
- Gemeinsame Teile (Klassen als CSS/Typst/LaTeX, Brand-Anbindung) liegen einmal im Repo.

## Offen

- [X]  Name der Extension: `tinh` (vietnamesisch *tính*, rechnen). Formate `tinh-<zweck>-<grundformat>`, siehe
  oben. Geprüft: auf GitHub keine Quarto-Extension und im Typst Universe kein Paket mit diesem Namen.
- [X]  Repo liegt bei mir (`matthiasbaitsch/quarto-tinh`). Da die Extension neutral ist, kann BCD sie verwenden,
  keine Abstimmung mit dem Team nötig.
- [X]  Skript und Aufgaben bleiben getrennt (`tinh-notes`, `tinh-assignments`), kein gemeinsames `tinh-dokument`.
- [X]  Zips der Aufgaben: Studierende rendern ihre Bearbeitung als einfaches `html` (eigene
  `lernpfad/aufgaben/quarto-template.yml`), also ohne Extension und Brand im Zip; so müssen sie sich nicht mit
  Folien beschäftigen.
- [X]  Aufteilung Extension, Brand und Projekt-Metadaten. In `hsbo-maba` ist nur das Logo auf der Titelfolie
  HSBO-spezifisch (`$title-logo` in `titlepage.scss`), Farben (`$jet`, `$accent`, `$accent2`) stammen aus dem
  Theme `clean`, Schrift ist Roboto.
  - Extension: Layout, Klassen, Größen, Übergänge; Farben und Roboto als Standard (von der Brand überschreibbar).
  - Brand (`_brand.yml` je Projekt): `logo` (HSBO bzw. BCD), `meta` (Name und Link der Einrichtung). Farben
    vorerst für HSBO und BCD gleich, also keine `color` in der Brand; ggf. später eigene Farben je Brand.
  - Projekt-Metadaten (`_quarto.yml`/`_metadata.yml`): `author`, `subtitle`, `date`, `lang` und `footer`
    (flexibler als aus der Brand gebildet; z. B. „Bausteine Computergestützter Datenanalyse“ in
    `bcd-bausteine-r`).
- [X]  Brand für LaTeX (`tinh-notes-pdf`, `tinh-assignments-pdf`) erstmal nicht wichtig. Brand-Unterstützung von
  LaTeX ist schwach, Logo und Farben müsste das Template selbst auslesen; ggf. später bzw. mit Umstellung auf Typst.

## Schritte

- [X]  Repo `matthiasbaitsch/quarto-tinh` anlegen, Inhalt von `hsbo-maba` als `tinh-slides` (revealjs, html)
  übernehmen, Logo auf der Titelfolie (`$title-logo`) aus der Brand statt fester HSBO-URL.
- [X]  Typst-Folienformat `tinh-slides-typst` aufnehmen: touying-Bridge (Lua-Filter, Templates aus
  `quarto-touying-typst`, MIT), Theme `clean`, eigene Titelfolie mit Logo aus der Brand, eigene `page.typ` ohne
  Quartos Logo auf jeder Seite.
- [X]  Gemeinsame Klassen in `tinh-slides` (revealjs, html, typst): `.neuerbegriff`, `.ja`/`.nein`, `.downN`
  (revealjs zusätzlich `.upN`, `.framed`, `.raw`).
- [X]  `tinh-notes` (html, pdf) und `tinh-assignments` (html, pdf) anlegen: CSS und LaTeX-Präambel aus
  `bcd-style-notes.css` bzw. `_bcd-setup.tex`, Filter `latex-environment` (MIT) mit `commands`/`environments`,
  `\printindex` (nur Skript). `tinh-notes-html` setzt das Logo der Brand über `toc-title`.
- [X]  `_brand.yml`: BCD in `bcd-bausteine-statistik` und `bcd-bausteine-r` (vorhanden, mit Logo als SVG bzw. PNG),
  HSBO in `lernpfad/_brand/_brand.yml` (Logo als URL, gemeinsam für die Projekte per `brand: ../_brand/_brand.yml`,
  in die Zips als `_brand.yml` kopiert). Logo-URLs gehen nur bei revealjs und HTML, nicht bei Typst. Lokale Logos
  werden als Daten-URI eingebettet (SVG, PNG, JPG). Größe auf der Titelfolie 1.5em.
- [X]  `bcd-bausteine-statistik` umstellen: Folien auf `tinh-slides-typst`, Skript und Aufgaben auf
  `tinh-notes-html`/`tinh-notes-pdf` (Logo aus der Brand statt `toc-title` mit festem Pfad). Entfernt:
  `_extensions/kazuyanagimoto/`, `_extensions/quarto-ext/`, `_bcd-setup.typ`, `_bcd-setup.tex`,
  `bcd-style-notes.css`. Makefile rendert nur `m-*/skript` und `m-*/aufgaben` mit `-t tinh-notes-*`.
- [X]  `bcd-bausteine-r` umstellen: Folien auf `tinh-slides-revealjs` (Fußzeile in `_quarto.yml`),
  `bcd-style-slides.scss` und `bcd-style-titlepage.scss` entfernt, CI rendert mit `-t tinh-slides-revealjs`.
- [X]  Lernpfad umstellen: `veranstaltung`, `r-folien` auf `tinh-slides-revealjs` (inkl. Kopie der Extension und
  Brand in die Zips), `statistik-skript` auf `tinh-notes-*` (HSBO-Brand), `aufgaben` auf `tinh-assignments-*`
  (Zips der Aufgaben: einfaches `html`). `content.yml` kopiert `_bcd-setup.tex` und `bcd-style-notes.css` nicht
  mehr. `make update-extension` im Makefile, `CLAUDE.md`, `README.md`.
- [X]  Punkte in `todo-umstellung-aufbau.md` anpassen („Typst-Folienformat später in `hsbo-maba`“ entfällt).
- [X]  Informatik umstellen und danach `hsbo-maba` löschen: als Punkt in die `todo.md` des Informatik-Projekts
  (`~/sciebo/lehrveranstaltungen/informatik-master_2.0/unterlagen`) verschoben, später.
