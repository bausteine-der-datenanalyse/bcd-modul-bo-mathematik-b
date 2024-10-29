clean:
	rm -rf _output aufgaben/c aufgaben/.quarto  folien/.quarto folien-r/c folien-r/.quarto

update:
	git submodule update --recursive --remote
	cp bausteine/bcd-bausteine-r/demo/folien/style.scss folien-r

commit:
	git add .
	git commit -m "WIP"
	git push

update-commit: update commit
