# Modul Mathematik B

Dokumente auf GitHub-Pages:

- [Skript Grundlagen der Statistik (html)](https://bausteine-der-datenanalyse.github.io/bcd-modul-bo-mathematik-b/skript/index.html)

- [Skript Grundlagen der Statistik (pdf)](https://bausteine-der-datenanalyse.github.io/bcd-modul-bo-mathematik-b/skript/skript-mathematik-b.pdf)

- [Folien zu R (html)](https://bausteine-der-datenanalyse.github.io/bcd-modul-bo-mathematik-b/folien-r-alle/index.html)

## Voraussetzungen

Folgende Software muss installiert sein:

- [Git](https://git-scm.com/)
- [R](https://cran.r-project.org/)
- [Quarto](https://quarto.org/)
- **rsvg-convert** – wird von Quarto benötigt, um SVG-Bilder in PDF zu konvertieren.

### rsvg-convert installieren

#### Windows

`rsvg-convert` kann über [MSYS2](https://www.msys2.org/) installiert werden.
In der **MSYS2 MinGW 64-bit**-Shell:

```bash
pacman -S mingw-w64-x86_64-librsvg
```

Nach der Installation prüfen, ob `rsvg-convert` im Systempfad verfügbar ist:

```bash
rsvg-convert --version
```

## Repository auschecken

```bash
git clone --recurse-submodules https://github.com/bausteine-der-datenanalyse/bcd-modul-bo-mathematik-b.git
```

## R-Pakete installieren

Eine R-Shell im Projektverzeichnis starten und Folgendes eingeben:

```r
options(install.packages.compile.from.source = &quot;never&quot;)
options(pkgType = &quot;binary&quot;)
install.packages(&quot;remotes&quot;)
remotes::install_deps(upgrade = &quot;always&quot;)
```

## Unterlagen erstellen

1. Im Projektverzeichnis die neuesten Änderungen holen:

```bash
git pull
git submodule update --remote
```

2. Im Ordner `folien-r-alle` das Sammelskript ausführen:

```bash
../bausteine/bcd-bausteine-montieren/collect-content.R
```

3. Quarto ausführen – je nach Bedarf einen oder mehrere der folgenden Befehle:

```bash
quarto render folien
quarto render aufgaben
quarto render folien-r
quarto render folien-r-alle
```
