## Copyright (C) 2020 Takayuki Goto

POLYML        := poly
POLYMLC       := polyc
POLYMLFLAGS   := -q --error-exit --use $(shell readlink -f script/load.sml)

PDFLATEX      := pdflatex
DIFF          := diff

PREFIX        := /usr/local/polyml
BINDIR        := bin
LIBDIR        := lib
DOCDIR        := doc/mlyacc-polyml

MLLEX         := mllex-polyml
MLYACC_POLYML := mlyacc-polyml

MLYACCLIB_VER := 1.0.0
MLYACCLIB     := mlyacc-lib-$(MLYACCLIB_VER).poly

DOCS          := doc/mlyacc-polyml.pdf

LIB_SRCS      := $(wildcard mlyacc-lib/*)
SRCS          := $(wildcard src/*) \
                 src/yacc.lex.sml \
                 src/yacc.grm.sig \
                 src/yacc.grm.sml

EXAMPLES      := calc fol pascal

export POLYML
export POLYMLC
export POLYMLFLAGS
export MLLEX
export BINDIR
export LIBDIR
export MLYACCLIB_VER


all: mlyacc-polyml


.PHONY: mlyacc-polyml
mlyacc-polyml: mlyacc-polyml-nodocs docs


.PHONY: mlyacc-polyml-nodocs
mlyacc-polyml-nodocs: $(BINDIR)/$(MLYACC_POLYML)


$(BINDIR)/$(MLYACC_POLYML): $(MLYACC_POLYML).o
	@echo "  [POLYMLC] $@"
	@$(POLYMLC) -o $@ $^


$(MLYACC_POLYML).o: $(LIBDIR)/$(MLYACCLIB) $(SRCS)
	@echo "  [POLYML] $@"
	@echo "" | $(POLYML) $(POLYMLFLAGS) \
		--eval 'PolyML.loadModule "./$<"' \
		--eval 'load "src/load.sml"' \
		--eval 'PolyML.export ("$@", Main.main)'


$(LIBDIR)/$(MLYACCLIB): $(LIB_SRCS)
	@echo "  [POLYML] $@"
	@echo "" | $(POLYML) $(POLYMLFLAGS) \
		--eval 'load "mlyacc-lib/load.sml"' \
		--use mlyacc-lib.sml \
		--eval 'PolyML.SaveState.saveModule ("$@", MLYaccLib)'


include Makefile.mlyacc


.PHONY: doc/mlyacc.pdf
doc/mlyacc.pdf:
	$(MAKE) -C doc PDFLATEX:=$(PDFLATEX) mlyacc.pdf


$(DOCS): doc/mlyacc.pdf
	cp doc/mlyacc.pdf $@


.PHONY: example
example: mlyacc-polyml-nodocs
	$(MAKE) -C ./examples \
		MLYACC=../$(BINDIR)/$(MLYACC_POLYML) \
		MLYACCLIB=../$(LIBDIR)/$(MLYACCLIB)


.PHONY: docs
docs: $(DOCS)


.PHONY: test
test: mlyacc-polyml-nodocs
	$(BINDIR)/$(MLYACC_POLYML) test/ml.grm
	$(DIFF) test/ml.grm.sig  test/ml.grm.sig.exp
	$(DIFF) test/ml.grm.sml  test/ml.grm.sml.exp
	$(DIFF) test/ml.grm.desc test/ml.grm.desc.exp
	$(RM)   test/ml.grm.{sig, sml, desc}


.PHONY: install-nodocs
install-nodocs: mlyacc-polyml-nodocs
	install -D -m 0755 -t $(PREFIX)/$(BINDIR) $(BINDIR)/$(MLYACC_POLYML)
	install -D -m 0644 -t $(PREFIX)/$(LIBDIR) $(LIBDIR)/$(MLYACCLIB)


.PHONY: install
install: install-nodocs docs
	install -D -m 0444 -t $(PREFIX)/$(DOCDIR) $(DOCS)


.PHONY: clean
clean:
	-$(RM) $(BINDIR)/$(MLYACC_POLYML) $(MLYACC_POLYML).o
	-$(RM) $(LIBDIR)/$(MLYACCLIB)
	$(MAKE) -C examples clean
	$(MAKE) -C doc clean

