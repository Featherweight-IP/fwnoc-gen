
MKDV_MK := $(abspath $(lastword $(MAKEFILE_LIST)))
TEST_DIR := $(dir $(MKDV_MK))

TOP_MODULE=bfm_driven_tb
MKDV_PLUGINS += pybfms cocotb

PYBFMS_MODULES += rv_bfms

MKDV_COCOTB_MODULE = openpiton_tests.bfm_driven

VLSIM_CLKSPEC += clock=10ns
VLSIM_OPTIONS += -Wno-fatal

MKDV_VL_SRCS += $(TEST_DIR)/bfm_driven_tb.sv
MKDV_VL_SRCS += $(TEST_DIR)/noc2rv_bridge.v

include $(TEST_DIR)/../common/defs_rules.mk
include $(MKDV_CACHEDIR)/design/defs_rules.mk

RULES := 1

include $(TEST_DIR)/../common/defs_rules.mk

$(MKDV_CACHEDIR)/design/defs_rules.mk :
	echo "Creating design"
	PATH=$(PACKAGES_DIR)/python/bin:$(PATH) python \
		$(OPENPITON_IC_DIR)/scripts/gensys.py \
		-o `dirname $@` \
		$(TEST_DIR)/bfm_driven.yaml
	

