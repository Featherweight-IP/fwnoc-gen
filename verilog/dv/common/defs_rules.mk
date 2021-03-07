
OPENPITON_IC_DV_COMMONDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
OPENPITON_IC_DIR := $(abspath $(OPENPITON_IC_DV_COMMONDIR)/../../..)
PACKAGES_DIR := $(OPENPITON_IC_DIR)/packages
DV_MK := $(shell PATH=$(PACKAGES_DIR)/python/bin:$(PATH) python3 -m mkdv mkfile)

ifneq (1,$(RULES))

MKDV_PYTHONPATH += $(OPENPITON_IC_DV_COMMONDIR)/python

include $(DV_MK)
else # Rules

include $(DV_MK)
endif
