set R="%USERPROFILE%\AppData\Local\Programs\R\R-4.5.1\bin\R"

%R% -e "install.packages(\"remotes\", repos = \"https://cran.uni-muenster.de\"); remotes::install_deps(upgrade = \"always\")" 

pause
