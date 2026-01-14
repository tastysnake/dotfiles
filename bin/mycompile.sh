#!/bin/bash

cd "/home/fabi/Documents/facu/trabajo_final/trabajo_final/latex"
pdflatex main
for chapter in main*blx.aux; do {
    bibtex $chapter
}
done

bibtex main
pdflatex main
pdflatex main

## the powershell equivalent

#ls main*blx.aux | Foreach-Object {
    #bibtex $_.FullName
#}
#
#bibtex main
#pdflatex main
#pdflatex main
