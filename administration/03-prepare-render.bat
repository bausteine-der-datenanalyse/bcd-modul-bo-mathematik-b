set RSCRIPT="%USERPROFILE%\AppData\Local\Programs\R\R-4.5.1\bin\Rscript"

cd ../folien-r-alle
%RSCRIPT% ../bausteine/bcd-bausteine-montieren/collect-content.R

cd ../skript
%RSCRIPT% ../bausteine/bcd-bausteine-montieren/collect-content.R

pause