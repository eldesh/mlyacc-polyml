## Copyright (C) 2020 Takayuki Goto

POLYML      := poly
POLYMLC     := polyc
POLYMLFLAGS := -q --error-exit --use $(shell readlink -f ./script/load.sml)
MLLEX       := mllex-polyml
MLYACC      := $(shell readlink -f mlyacc-polyml)

PDFLATEX    := pdflatex
DIFF        := diff

PREFIX      := /usr/local

TARGET      := mlyacc-polyml

MLYACCLIB_VERSION := 1.0.0
MLYACCLIB   := mlyacc-lib-$(MLYACCLIB_VERSION).poly

DOCS        := mlyacc-polyml.pdf

LIB_SRCS := $(wildcard lib/*)
SRCS     := $(wildcard src/*) \
            src/yacc.lex.sml  \
            src/yacc.grm.sig  \
            src/yacc.grm.sml

EXAMPLES := calc fol pascal

export POLYML
export POLYMLC
export POLYMLFLAGS
export MLLEX
export MLYACC
export MLYACCLIB_VERSION
export MLYACCLIB


all:	$(TARGET) $(DOCS)


$(TARGET): $(TARGET).o
	@echo "  [POLYMLC] $@"
	@$(POLYMLC) -o $@ $^


$(TARGET).o: $(MLYACCLIB) $(SRCS)
	@echo "  [POLYML] $@"
	@echo "" | $(POLYML) $(POLYMLFLAGS) \
		--eval 'PolyML.loadModule "./$<"' \
		--eval 'load "src/load.sml"' \
		--eval 'PolyML.export ("$@", Main.main)'


$(MLYACCLIB): $(LIB_SRCS)
	@echo "  [POLYML] $@"
	@echo "" | $(POLYML) $(POLYMLFLAGS) \
		--eval 'load "lib/load.sml"' \
		--use mlyacc-lib.sml \
		--eval 'PolyML.SaveState.saveModule ("$@", MLYaccLib)'


include Makefile.mlyacc


doc/mlyacc.pdf:
	$(MAKE) -C doc PDFLATEX:=$(PDFLATEX) mlyacc.pdf


$(TARGET).pdf: doc/mlyacc.pdf
	cp doc/mlyacc.pdf $@


.PHONY: examples
examples: $(TARGET)
	$(MAKE) -C ./examples MLYACCLIB=../$(MLYACCLIB)


.PHONY: docs
docs: $(DOCS)


.PHONY: test
test: $(TARGET)
	./$(TARGET) test/ml.grm
	$(DIFF) test/ml.grm.sig  test/ml.grm.sig.exp
	$(DIFF) test/ml.grm.sml  test/ml.grm.sml.exp
	$(DIFF) test/ml.grm.desc test/ml.grm.desc.exp
	$(RM)   test/ml.grm.{sig, sml, desc}


.PHONY: install
ifeq ($(shell which $(PDFLATEX) 2>/dev/null),)
install: $(TARGET)
	install -D -m 0755 -t $(PREFIX)/bin                 $(TARGET)
	install -D -m 0644 -t $(PREFIX)/lib                 $(MLYACCLIB)
else
install: $(TARGET) $(DOCS)
	install -D -m 0755 -t $(PREFIX)/bin                 $(TARGET)
	install -D -m 0644 -t $(PREFIX)/lib                 $(MLYACCLIB)
	install -D -m 0444 -t $(PREFIX)/share/mlyacc-polyml $(DOCS)
endif


.PHONY: clean
clean:
	-$(RM) $(TARGET) $(TARGET).o
	-$(RM) $(MLYACCLIB)
	$(MAKE) -C examples clean
	$(MAKE) -C doc clean

