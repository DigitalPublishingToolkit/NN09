# Generic Makefile
alldocx=$(wildcard docx/*.docx)
allmarkdown=$(filter-out md/book.md, $(wildcard md/*.md))
markdowns_compound=compound_src.md
epub=book.epub
icmls=$(wildcard icml/*.icml)

test: $(md)
	echo $(addprefix md/, \
	$(notdir \
	$(basename \
	$(wildcard docx/*.docx)))) ; \
	done

markdowns:$(alldocx) # convert docx to md
	for i in $(alldocx) ; \
	do md=md/`basename $$i .docx`.md ; \
	pandoc $$i \
	       	--from=docx \
		--to=markdown \
	       	--atx-headers \
		--template=essay.md.template \
		-o $$md ; \
	done


icmls: $(allmarkdown)
	for i in $(allmarkdown) ; \
	do icml=icml/`basename $$i .md`.icml ; \
	./scripts/md_stripmetada.py $$i > md/tmp.md ; \
	pandoc md/tmp.md \
		--from=markdown \
		--to=icml \
		--self-contained \
		-o $$icml ; \
	done


book.md: $(allmarkdown)
	for i in $(allmarkdown) ; \
	do ./scripts/md_stripmetada.py $$i >> md/book.md ; \
	done


ls_md:markdowns $(allmarkdown) # can be become compound rule
	for i in $(allmarkdown) ; \
	do echo $$i; \
	done


# Rule to build the entire book as a single markdown file from the markdown files inside md/





book.epub: compound_src.md epub/metadata.xml epub/styles.epub.css epub/cover.png
	pandoc \
		--from markdown \
		--to epub3 \
		--self-contained \
		--epub-chapter-level=2 \
		--epub-stylesheet=epub/styles.epub.css \
		--epub-cover-image=epub/cover.png \
		--epub-metadata=epub/metadata.xml \
		--epub-embed-font=lib/UbuntuMono-B.ttf \
		--default-image-extension png \
		--toc-depth=2 \
		-o book.epub \
		compound_src.md



clean:  # remove outputs
	rm md/book.md -f
	rm book.epub -f
	rm *~ */*~ -f #emacs files
# improve rule: rm if file exits
