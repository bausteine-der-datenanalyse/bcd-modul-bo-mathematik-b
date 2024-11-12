clean:
	rm -rf _output aufgaben/c aufgaben/.quarto  folien/.quarto folien-r/c folien-r/.quarto

update:
	git submodule update --recursive --remote
	cp bausteine/bcd-bausteine-r/demo/folien-r/style.scss folien-r

render:
	quarto render aufgaben
	quarto render folien-r

commit:
	git add .
	git commit -m "WIP"
	git push

update-commit: update commit
