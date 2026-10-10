# Modul Mathematik B

Lehrmaterial für das Modul "Mathematik B" (Statistik und Datenanalyse), erstellt mit
[Quarto](https://quarto.org/) und R.

Dokumente auf GitHub-Pages:

- [Skript Grundlagen der Statistik (html)](https://bausteine-der-datenanalyse.github.io/bcd-modul-bo-mathematik-b/skript/index.html)

- [Skript Grundlagen der Statistik (pdf)](https://bausteine-der-datenanalyse.github.io/bcd-modul-bo-mathematik-b/skript/skript-mathematik-b.pdf)

- [Folien zu R (html)](https://bausteine-der-datenanalyse.github.io/bcd-modul-bo-mathematik-b/folien-r-alle/index.html)

Installation und Erstellen der Unterlagen: siehe [INSTALLATION.md](INSTALLATION.md).

## Aufbau

```
bausteine/                 Git-Submodule mit den eigentlichen Inhalten
  bcd-bausteine-statistik    Statistik: Skript, Aufgaben (Module m-*)
  bcd-bausteine-r            R: Folien, Aufgaben (Module w-*)
  bcd-bausteine-montieren    collect-content.R zum Zusammensetzen
lernpfad/                  Quarto-Projekte des Lernpfads
  skript                     Skript (HTML + PDF)
  aufgaben                   Aufgabenblätter mit Lösungen (HTML + PDF)
  folien                     Folien der Präsenzveranstaltung (revealjs)
  folien-r                   R-Folien, einzeln und als Zip zum Herunterladen
  folien-r-alle              alle R-Folien in einem Dokument
weitere-unterlagen/        sonstiges Material (Schreiben/Präsentieren mit Quarto)
_output/                   gerenderte Unterlagen, wird auf GitHub Pages veröffentlicht
```

### Bausteine zusammensetzen

Die Inhalte werden nicht in den Projektordnern geschrieben, sondern in den Bausteine-Repos. Jedes Projekt
außer `lernpfad/folien` hat eine `content.yml`. Sie legt fest, welche Bausteine
`bausteine/bcd-bausteine-montieren/collect-content.R` in den Ordner `c/` des Projekts kopiert. Quarto rendert
anschließend den Inhalt von `c/`.

```
bausteine/*  --collect-content.R + content.yml-->  <projekt>/c/  --quarto render-->  _output/<projekt>
```

`c/` wird bei jedem Lauf geleert und neu befüllt – dort nichts von Hand ändern. Inhaltliche Änderungen gehören
in die Bausteine, die Auswahl und Reihenfolge in die `content.yml`. Aufbau und Möglichkeiten der `content.yml`
sind in der [README von bcd-bausteine-montieren](bausteine/bcd-bausteine-montieren/README.md) beschrieben.

| Projekt                | Quelle                                         | Ergebnis in `c/`                                   |
|------------------------|------------------------------------------------|----------------------------------------------------|
| `lernpfad/skript`      | `m-*/skript` aus `bcd-bausteine-statistik`     | ein Kapitel `NN-name.qmd` je Modul                 |
| `lernpfad/aufgaben`    | `m-*/aufgaben` und `w-*/aufgaben`              | `aufgabenblatt-N.qmd` und Lösungsblatt, Zips       |
| `lernpfad/folien-r`    | `w-*/folien` aus `bcd-bausteine-r`             | ein Foliensatz `NN-name.qmd` je Modul, Zips        |
| `lernpfad/folien-r-alle` | `w-*/folien` aus `bcd-bausteine-r`           | alle Foliensätze als Kapitel eines Dokuments       |
| `weitere-unterlagen`   | `w-schreiben-mit-quarto`, `w-praesentationen-mit-quarto` | Zips zum Herunterladen                   |

### Aussehen

`lernpfad/folien` und `lernpfad/folien-r` verwenden die Quarto-Extension
[hsbo-maba](https://github.com/matthiasbaitsch/quarto-hsbo-maba) (Format `hsbo-maba-revealjs`), die in beiden
Ordnern unter `_extensions/` liegt. Aktualisieren mit `make update-extension`. Die übrigen Projekte beziehen
ihren Stil (`bcd-style-notes.css`, `_bcd-setup.tex`) aus `bcd-bausteine-statistik`.

## Schnellstart

```bash
make update-from-github   # git pull + Submodule aktualisieren
make render               # Bausteine zusammensetzen und alle Projekte rendern
make clean                # _output und alle generierten Dateien entfernen
```

Bei jedem Push auf `main` rendert GitHub Actions die Unterlagen mit `make render` und veröffentlicht `_output`
auf GitHub Pages.
