#!/bin/bash
scriptdir="/home/yochai/github/cairn/scripts"
sourcedir="/home/yochai/github/cairn/resources/monsters"
tmpdir="/home/yochai/Downloads/tmp"
destdir="/home/yochai/Google Drive/Games/OSR/Into The Odd/hacks/Cairn/Monsters"
mkdir -p $tmpdir/monsters
rsync -av $sourcedir/ $tmpdir/monsters/
sed -i -f sources/prep.sed $tmpdir/monsters/*.md
cat $tmpdir/monsters/*.md >> $tmpdir/cairn-bestiary-tmp.md
cp sources/a5.tex $tmpdir/cairn-bestiary.tex
pandoc $tmpdir/cairn-bestiary-tmp.md -f markdown -t latex -o $tmpdir/cairn-bestiary-tmp.tex
cat $tmpdir/cairn-bestiary-tmp.tex >> $tmpdir/cairn-bestiary.tex
sed -i '$a \\\newpage\\null\\thispagestyle{empty}\\newpage' $tmpdir/cairn-bestiary.tex
sed -i '$a \\\end{document}' $tmpdir/cairn-bestiary.tex
pdflatex -output-directory=$tmpdir $tmpdir/cairn-bestiary.tex 
pdflatex -output-directory=$tmpdir $tmpdir/cairn-bestiary.tex
pdfjam --a5paper --booklet true --landscape "$tmpdir/cairn-bestiary.pdf" -o "$tmpdir/cairn-bestiary-booklet.pdf" --preamble '\usepackage{everyshi} \makeatletter \EveryShipout{\ifodd\c@page\pdfpageattr{/Rotate 180}\fi} \makeatother'
mv $tmpdir/cairn-bestiary.pdf "$destdir/cairn-bestiary-a5.pdf"
mv $tmpdir/cairn-bestiary-booklet.pdf "$destdir/cairn-bestiary-a5-booklet.pdf"
rm -rf $tmpdir