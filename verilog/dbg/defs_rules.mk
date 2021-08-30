
FWNOC_VERILOG_DBGDIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))


ifneq (1,$(RULES))
ifeq (,$(findstring $(FWNOC_VERILOG_DBGDIR),$(MKDV_INCLUDED_DEFS)))
MKDV_INCLUDED_DEFS += $(FWNOC_VERILOG_DBGDIR)

MKDV_PYTHONPATH += $(FWNOC_VERILOG_DBGDIR)/python
MKDV_VL_DEFINES += L2_DBG_MODULE=fwnoc_l2_dbg_bfm
PYBFMS_MODULES += fwnoc_dbg_bfms
endif

else # Rules

endif
