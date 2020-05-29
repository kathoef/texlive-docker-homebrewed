# texlive-docker-tailored

```
docker image build . -t texlive-tailored
docker run -v $(pwd):/home -it texlive-tailored latexmk -f -bibtex -pdf -pdflatex="pdflatex --shell-escape" example.tex
```
