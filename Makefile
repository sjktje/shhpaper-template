all: main.pdf

clean:
	rm -f main.log main.aux main.aux2 main.toc main.out main.blg main.bbl main.brf main.bcf main.run.xml preamble.aux

distclean: clean
	rm -f main.pdf

%.pdf: main.tex $(wildcard *.tex) $(wildcard *.bib) $(wildcard ../*.bib) $(wildcard chapters/*.tex)
	pdflatex -file-line-error $< </dev/null ||:
	biber $(patsubst %.tex,%,$<)
	while ! diff -q $(basename $<).aux $(basename $<).aux2 > /dev/null; do \
		cp $(basename $<).aux $(basename $<).aux2 2> /dev/null || :> $(basename $<).aux2 ; \
		pdflatex -file-line-error $< </dev/null ||: ; \
	done
	rm -f *.log *.aux2
viewpdf: main.pdf
	osascript\
	    -e "set theFile to POSIX file \"main.pdf\" as alias" \
	    -e "set thePath to POSIX path of theFile" \
	    -e "tell application \"Skim\"" \
	    -e "	activate" \
	    -e "	set theDocs to get documents whose path is thePath" \
	    -e " 	try" \
	    -e " 		if (count of theDocs) > 0 then revert theDocs" \
	    -e " 	end try" \
	    -e " 	open theFile" \
	    -e "end tell"
