# texlive-docker-homebrewed

```
docker image build . -t texlive-homebrewed
docker run -v $(pwd):/home -it texlive-homebrewed latexmk -f -bibtex -pdf -pdflatex="pdflatex --shell-escape" example.tex
```
