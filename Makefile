## Copyright (C) 2020 Takayuki Goto

POLYML      := poly
POLYMLC     := polyc
POLYMLFLAGS := -q --error-exit \
               --eval 'PolyML.suffixes := ".sig"::(!PolyML.suffixes)' \
               --use  script/load.sml
MLLEX       := mllex-polyml
MLYACC      := mlyacc-polyml

PDFLATEX    := pdflatex
DIFF        := diff

PREFIX      := /usr/local

NAME        := mlyacc-polyml
LIBNAME     := libmlyacc.poly

DOCS        := mlyacc-polyml.pdf

LIB_SRCS := $(wildcard lib/*)
SRCS     := $(wildcard src/*) \
            src/yacc.lex.sml  \
            src/yacc.grm.sig  \
            src/yacc.grm.sml


all:	$(NAME) $(DOCS)


$(NAME): $(NAME).o
	@echo "  [POLYMLC] $@"
	@$(POLYMLC) -o $@ $^


$(NAME).o: $(LIBNAME) $(SRCS)
	@echo "  [POLYML] $@"
	@echo "" | $(POLYML) $(POLYMLFLAGS) \
		--eval 'PolyML.loadModule "./$<"' \
		--eval 'load "src/load.sml"' \
		--eval 'PolyML.export ("$@", Main.main)'


$(LIBNAME): $(LIB_SRCS)
	@echo "  [POLYML] $@"
	@echo "" | $(POLYML) $(POLYMLFLAGS) \
		--eval 'load "lib/load.sml"' \
		--use mlyacc-lib.sml \
		--eval 'PolyML.SaveState.saveModule ("$@", MLYaccLib)'


src/%.lex.sml: src/%.lex
	@echo "  [MLLex] $@"
	@$(MLLEX) $<
	@chmod -w $<.*


src/%.grm.sig src/%.grm.sml: src/%.grm
	@echo "  [MLYacc] $@"
	@$(MLYACC) $<
	@chmod -w $<.*


doc/mlyacc.pdf:
	$(MAKE) -C doc PDFLATEX:=$(PDFLATEX) mlyacc.pdf


$(NAME).pdf: doc/mlyacc.pdf
	cp doc/mlyacc.pdf $@


.PHONY: docs
docs: $(DOCS)


.PHONY: test
test: $(NAME)
	$(NAME) test/ml.grm
	$(DIFF) test/ml.grm.sig  test/ml.grm.sig.exp
	$(DIFF) test/ml.grm.sml  test/ml.grm.sml.exp
	$(DIFF) test/ml.grm.desc test/ml.grm.desc.exp
	$(RM)   test/ml.grm.{sig, sml, desc}


.PHONY: install
ifeq ($(shell which $(PDFLATEX) 2>/dev/null),)
install: $(NAME)
	install -D -m 0755 -t $(PREFIX)/bin/                 $(NAME)
	install -D -m 0644 -t $(PREFIX)/lib/polyml           $(LIBNAME)
else
install: $(NAME) $(DOCS)
	install -D -m 0755 -t $(PREFIX)/bin/                 $(NAME)
	install -D -m 0644 -t $(PREFIX)/lib/polyml           $(LIBNAME)
	install -D -m 0444 -t $(PREFIX)/share/mlyacc-polyml/ $(DOCS)
endif


.PHONY: clean
clean:
	-$(RM) $(NAME) $(NAME).o
	-$(RM) $(LIBNAME)
	$(MAKE) -C doc clean

