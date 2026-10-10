# Installation

## Voraussetzungen

Folgende Software muss installiert sein:

- [Git](https://git-scm.com/)
- [R](https://cran.r-project.org/)
- [Quarto](https://quarto.org/)
- **rsvg-convert** – wird von Quarto benötigt, um SVG-Bilder in PDF zu konvertieren.


### rsvg-convert installieren

#### macOS (Homebrew)

```bash
brew install librsvg
```
#### Windows

Unter Windows wird rsvg-convert über [Chocolatey](https://chocolatey.org/) installiert,
einen Paketmanager für Windows.

**Schritt 1: Chocolatey installieren (einmalig)**

 PowerShell **als Administrator** öffnen:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

**Schritt 2: rsvg-convert installieren**

```powershell
choco install rsvg-convert
```

**Schritt 3: Prüfen**

Eine **neue** PowerShell öffnen und testen:

```powershell
rsvg-convert --version
```

Wenn eine Versionsnummer erscheint, hat alles geklappt.

## Repository auschecken

```bash
git clone --recurse-submodules https://github.com/bausteine-der-datenanalyse/bcd-modul-bo-mathematik-b.git
```

## R-Pakete installieren

Eine R-Shell im Projektverzeichnis starten und Folgendes eingeben:

```r
options(install.packages.compile.from.source = "never")
options(pkgType = "binary")
install.packages("remotes")
remotes::install_deps(upgrade = "always")
```

Alternativ `make bootstrap`.

## Unterlagen erstellen

1. Im Projektverzeichnis die neuesten Änderungen holen (oder `make update-from-github`):

```bash
git pull
git submodule update --remote
```

2. Inhalte aus den Bausteinen zusammensetzen (füllt die Ordner `c/`):

```bash
make prepare-render
```

Für ein einzelnes Projekt das Sammelskript im jeweiligen Projektordner ausführen, z. B.:

```bash
cd lernpfad/skript
../../bausteine/bcd-bausteine-montieren/collect-content.R
```

3. Quarto ausführen – alles mit `make render` oder einzeln:

```bash
quarto render lernpfad/skript
quarto render lernpfad/aufgaben
quarto render lernpfad/folien
quarto render lernpfad/folien-r
quarto render lernpfad/folien-r-alle -t html
quarto render weitere-unterlagen
```

Die Ausgabe landet in `_output/<projekt>`.
