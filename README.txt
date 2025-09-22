# Modul Mathematik B

## Von Github auschecken

Die Submodulee sind via `git@github.com` eingebunden, auf Github muss daher ein SSH-Schlüssel hinterlegt sein. Falls ein GUI-Client verwendet wird, muss man einmal von der Kommandozeile aus auf Github zugreifen, damit der Host als vertrauenswürdig gespeichert wird.

## Pakete installieren

R-Shell im Projektverzeichnis starten und folgendes eingeben:

```r
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


