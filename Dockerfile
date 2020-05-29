FROM ubuntu:20.04

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update --yes \
 && apt-get install --yes --no-install-recommends \
    # Required for Pygments>=2.6
    python-is-python3 python3-pip \
    # Required for manual TeXLive installation
    wget cpanminus \
    # Required for correctly setting PDF build datetimes
    tzdata \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install Pygments

# https://tex.stackexchange.com/questions/342612/tex-live-installation-specify-just-the-scheme-on-the-command-line
# https://gist.github.com/seisman/ad00252a9f03fc644146a11e6983d9c5

RUN wget --quiet http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
 && tar -zxvf install-tl-unx.tar.gz \
 && echo 'selected_scheme scheme-basic' > texlive.profile \
 && ./install-tl-20*/install-tl -profile texlive.profile \
 && rm -r texlive.profile install-tl-*

ENV PATH=/usr/local/texlive/2020/bin/x86_64-linux:$PATH

# Hacky installation procedure for required packages
# https://tex.stackexchange.com/questions/110501/auto-package-download-for-texlive

RUN tlmgr install texliveonfly latexmk

COPY example.tex references.bib ./
RUN texliveonfly --compiler=latexmk --arguments='-shell-escape -pdf -bibtex' example.tex && latexmk -C

# Timezone stuff.
# https://stackoverflow.com/questions/44331836/apt-get-install-tzdata-noninteractive

RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata

WORKDIR /home
