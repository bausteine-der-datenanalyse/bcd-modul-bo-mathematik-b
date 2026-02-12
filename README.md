# Modul Mathematik B

Dokumente auf GitHub-Pages:

- [Skript Grundlagen der Statistik (html)](https://bausteine-der-datenanalyse.github.io/bcd-modul-bo-mathematik-b/skript/index.html)

- [Skript Grundlagen der Statistik (pdf)](https://bausteine-der-datenanalyse.github.io/bcd-modul-bo-mathematik-b/skript/skript-mathematik-b.pdf)

- [Folien zu R (html)](https://bausteine-der-datenanalyse.github.io/bcd-modul-bo-mathematik-b/folien-r-alle/index.html)

## Von Github auschecken

Kommandozeile:

```bash
git clone --recurse-submodules https://github.com/bausteine-der-datenanalyse/bcd-modul-bo-mathematik-b.git
```

## Pakete installieren

R-Shell im Projektverzeichnis starten und folgendes eingeben:

```r
options(install.packages.compile.from.source = "never")
options(pkgType = "binary")
install.packages("remotes")
remotes::install_deps(upgrade = "always")
```

## Unterlagen erstellen

1. Im Projektverzeichnis die Befehle

    ```bash
    git pull
    git submodule update --remote 
    ```

    ausführen

1. Im Ordner `folien-r-alle` den Befehl

    ```bash
    ../bausteine/bcd-bausteine-montieren/collect-content.R
    ```

    ausführen.

1. Quarto ausführen: Je nach Bedarf einen oder alle der folgenden Befehle:

    ```bash
    quarto render folien
    quarto render aufgaben
    quarto render folien-r
    quarto render folien-r-alle
    ```
