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


SRCS     := $(wildcard src/*)
LIB_SRCS := $(wildcard lib/*)


all:	$(NAME)


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


src/yacc.lex.sml: src/yacc.lex
	-$(RM) $<.*
	$(MLLEX) $<
	chmod -w $<.*


src/%.grm.sig src/%.grm.sml: src/%.grm
	-$(RM) $<.* 
	$(MLYACC) $<
	chmod -w $<.*


.PHONY: clean
clean:
	-$(RM) $(NAME) $(NAME).o
	-$(RM) $(LIBNAME)

