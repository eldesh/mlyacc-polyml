## Copyright (C) 2020 Takayuki Goto

POLYML      ?= poly
POLYMLC     ?= polyc
POLYMLFLAGS ?= -q --error-exit --use ../script/load.sml
MLLEX       ?= mllex-polyml
MLYACC      ?= ../mlyacc-polyml
MLYACCLIB_VERSION ?= 1.0.0
MLYACCLIB   ?= ../mlyacc-lib-$(MLYACCLIB_VERSION).poly

EXAMPLES := calc.poly fol.poly pascal.poly

include ../Makefile.mlyacc


define build-module
@echo "  [POLYML] $@"
@echo "" | $(POLYML) $(POLYMLFLAGS) \
	--eval 'PolyML.loadModule "$(MLYACCLIB)"' \
	--eval 'load "./$(1)/load.sml"' \
	--use ./$(1)/export.sml \
	--eval 'PolyML.SaveState.saveModule ("$@", $(2))'
endef


all: $(EXAMPLES)


calc.poly: $(MLYACCLIB) $(addprefix calc/,calc.sml calc.lex.sml calc.grm.sml calc.grm.sig load.sml export.sml)
	$(call build-module,calc,Calc)


fol.poly: $(MLYACCLIB) $(addprefix fol/,absyn.sml fol.grm.sml fol.grm.sig fol.lex.sml interface.sml link.sml parse.sml load.sml export.sml)
	$(call build-module,fol,Fol)


pascal.poly: $(MLYACCLIB) $(addprefix pascal/,pascal.grm.sig pascal.grm.sml pascal.lex.sml parser.sml load.sml export.sml)
	$(call build-module,pascal,Pascal)


.PHONY: clean
clean:
	-$(RM) $(addprefix calc/calc.grm,.sml .sig .desc)
	-$(RM) calc/calc.lex.sml
	-$(RM) $(addprefix fol/fol.grm,.sml .sig .desc)
	-$(RM) fol/fol.lex.sml
	-$(RM) $(addprefix pascal/pascal.grm,.sml .sig .desc)
	-$(RM) pascal/pascal.lex.sml
	-$(RM) $(EXAMPLES)

