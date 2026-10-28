# Modul Mathematik B

Lehrmaterial für das Modul "Mathematik B" (Statistik und Datenanalyse), erstellt mit
[Quarto](https://quarto.org/) und R.

Dokumente auf GitHub-Pages:

- [Skript Grundlagen der Statistik (html)](https://bausteine-der-datenanalyse.github.io/bcd-modul-bo-mathematik-b/lernpfad/statistik-skript/index.html)

- [Skript Grundlagen der Statistik (pdf)](https://bausteine-der-datenanalyse.github.io/bcd-modul-bo-mathematik-b/lernpfad/statistik-skript/skript-mathematik-b.pdf)

- [Folien zu R (html)](https://bausteine-der-datenanalyse.github.io/bcd-modul-bo-mathematik-b/lernpfad/r-folien-alle/index.html)

Installation und Erstellen der Unterlagen: siehe [INSTALLATION.md](INSTALLATION.md).

## Grundsatz

Die Veranstaltung ist ein inverted classroom: Vieles wird in Videos erklärt, in Präsenz werden Fragen
besprochen und Aufgaben bearbeitet. Daraus ergibt sich die Trennung:

- **Material** (Skript, Folien, Aufgaben) ist nach Themen geordnet und liegt in den Bausteinen. Ob ein
  Foliensatz im Video oder in Präsenz verwendet wird, ist keine Eigenschaft der Folien.
- **Ablauf** (welche Woche was, Agenda) steht nur in Moodle: Die Wochen-Tabs enthalten Agenda und Links auf die
  Unterlagen.
- Was nur zu dieser Veranstaltung gehört (Einführung, Studienarbeit), liegt in `bausteine/veranstaltung` und
  bindet die allgemeinen Bausteine an die Vorlesung an.

## Aufbau

```
bausteine/                 Git-Submodule mit den eigentlichen Inhalten
  bcd-bausteine-statistik    Statistik: Skript, Aufgaben (Module m-*)
  bcd-bausteine-r            R: Folien, Aufgaben (Module w-*)
  bcd-bausteine-montieren    collect-content.R zum Zusammensetzen
  veranstaltung              nur für diese Veranstaltung (Einführung, …), kein Submodul
lernpfad/                  Quarto-Projekte des Lernpfads, Namen nach dem Muster <quelle>-<art>
  statistik-skript           Skript Statistik (HTML + PDF)
  statistik-folien           Folien Statistik (PDF, Typst)
  r-folien                   R-Folien, einzeln und als Zip zum Herunterladen
  r-folien-alle              alle R-Folien in einem Dokument
  aufgaben                   Aufgabenblätter mit Lösungen (HTML + PDF)
  veranstaltung              Folien zur Veranstaltung (Einführung, …), einzeln und als Zip
  weitere-unterlagen         sonstiges Material (Schreiben/Präsentieren mit Quarto)
__output/                   gerenderte Unterlagen, wird auf GitHub Pages veröffentlicht
_quarto.yml                Quarto-Projekt für alles außer statistik-skript, r-folien-alle, weitere-unterlagen
_brand/                    HSBO-Brand (hsbo-brand)
_extensions/               Quarto-Extension tinh
```

### Bausteine zusammensetzen

Die Inhalte werden nicht in den Projektordnern geschrieben, sondern in den Bausteine-Repos. Jedes Projekt hat
eine `content.yml`. Sie legt fest, welche Bausteine `bausteine/bcd-bausteine-montieren/collect-content.R` in den
Ordner `c/` des Projekts kopiert. Quarto rendert anschließend den Inhalt von `c/`.

```
bausteine/*  --collect-content.R + content.yml-->  <projekt>/c/  --quarto render-->  __output/<pfad>
```

`c/` wird bei jedem Lauf geleert und neu befüllt – dort nichts von Hand ändern. Inhaltliche Änderungen gehören
in die Bausteine, die Auswahl und Reihenfolge in die `content.yml`. Aufbau und Möglichkeiten der `content.yml`
sind in der [README von bcd-bausteine-montieren](bausteine/bcd-bausteine-montieren/README.md) beschrieben.

| Projekt                   | Quelle                                         | Ergebnis in `c/`                                   |
|---------------------------|------------------------------------------------|----------------------------------------------------|
| `lernpfad/statistik-skript` | `m-*/skript` aus `bcd-bausteine-statistik`   | ein Kapitel `NN-name.qmd` je Modul                 |
| `lernpfad/statistik-folien` | `m-*/folien` aus `bcd-bausteine-statistik`  | `folien/NN-name.qmd` je Modul, Bilder/Daten in `skript/` |
| `lernpfad/r-folien`       | `w-*/folien` aus `bcd-bausteine-r`             | ein Foliensatz `NN-name.qmd` je Modul, Zips        |
| `lernpfad/r-folien-alle`  | `w-*/folien` aus `bcd-bausteine-r`             | alle Foliensätze als Kapitel eines Dokuments       |
| `lernpfad/aufgaben`       | `m-*/aufgaben` und `w-*/aufgaben`              | `aufgabenblatt-N.qmd` und Lösungsblatt, Zips       |
| `lernpfad/veranstaltung`  | `*/folien` aus `bausteine/veranstaltung`       | ein Foliensatz `NN-name.qmd` je Ordner, Zips       |
| `lernpfad/weitere-unterlagen` | `w-schreiben-mit-quarto`, `w-praesentationen-mit-quarto` | Zips zum Herunterladen                   |

### Quarto-Projekte

Wie im Informatik-Projekt gibt es ein Quarto-Projekt im Hauptordner (`_quarto.yml`, `_brand/`,
`_extensions/`). Nur die Books `lernpfad/statistik-skript` und `lernpfad/r-folien-alle` sowie
`lernpfad/weitere-unterlagen` (eigenständige Projekte wie bei den Studierenden) haben ein eigenes `_quarto.yml`. `statistik-skript` und `r-folien-alle` finden Extension und Brand über Symlinks, die `collect-content.R` anlegt. Die
übrigen Projekte haben nur ein `_metadata.yml` (falls nötig), das auch für `c/` gilt. Die Ausgabe landet unter
demselben Pfad in `__output`, z. B. `__output/lernpfad/r-folien`.

### Aussehen

`lernpfad/veranstaltung` und `lernpfad/r-folien` verwenden die neutrale Quarto-Extension
[quarto-tinh](https://github.com/matthiasbaitsch/quarto-tinh) (Format `tinh-slides-revealjs`), die in beiden
Hauptordner unter `_extensions/` liegt. Aktualisieren mit `make update-extension`. Logo und Name der Hochschule
kommen aus der Brand [hsbo-brand](https://github.com/matthiasbaitsch/hsbo-brand) in `_brand/`, ebenfalls mit `make update-extension` aktualisiert. `statistik-skript` und `r-folien-alle` verwenden `tinh-notes`, `aufgaben` verwendet
`tinh-assignments` aus derselben Extension.

## Schnellstart

```bash
make update-from-github   # git pull + Submodule aktualisieren
make render               # Bausteine zusammensetzen und alle Projekte rendern
make clean                # __output und alle generierten Dateien entfernen
```

Bei jedem Push auf `main` rendert GitHub Actions die Unterlagen mit `make publish` (inklusive PDF der Folien) und veröffentlicht `__output`
auf GitHub Pages.
