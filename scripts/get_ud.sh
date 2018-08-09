#!/bin/bash

git clone https://github.com/UniversalDependencies/UD_English-EWT --branch=r2.2
pip install -U semstr
ls xml | sed 's/\..*/$/' | grep -f- streusle2ucca.txt | awk '/./{print "reviews-"$1}' | xargs python -m semstr.scripts.split UD_English-EWT/*.conllu -o ud --doc-ids

