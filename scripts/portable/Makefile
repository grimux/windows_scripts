CC=pandoc
PFLAG=-s -t html5 --pdf-engine=wkhtmltopdf --css $(GITCSS) -o
HFLAG=-s -t html5 --pdf-engine=wkhtmltopdf --css $(GITCSS) --self-contained -o
MK=$(wildcard *.md)
PDF=$(patsubst %.md, pdf/%.pdf, $(MK))
HTML=$(patsubst %.md, html/%.html, $(MK))

all: pdf html

pdf: $(PDF)

$(PDF): pdf/%.pdf : %.md
	@if [ ! -d "pdf/" ]; then\
		mkdir pdf;\
	fi
	$(CC) $< $(PFLAG) $@

html: $(HTML) 

$(HTML): html/%.html : %.md
	@if [ ! -d "html/" ]; then\
		mkdir html;\
	fi
	$(CC) $< $(HFLAG) $@

.PHONY: clean

clean:
	@echo "Cleaning up..."
	rm -rf html/ pdf/
