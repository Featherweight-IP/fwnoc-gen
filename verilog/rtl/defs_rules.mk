OPENPITON_IC_VERILOG_RTLDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

ifneq (1,$(RULES))

ifeq (,$(findstring $(OPENPITON_IC_VERILOG_RTLDIR),$(MKDV_INCLUDED_DEFS)))
MKDV_INCLUDED_DEFS += $(OPENPITON_IC_VERILOG_RTLDIR)
MKDV_VL_DEFINES += PITON_NO_CHIP_BRIDGE
#MKDV_VL_DEFINES += PITON_CLKS_CHIPSET
#MKDV_VL_DEFINES += PITON_CHIPSET_CLKS_GEN

MKDV_VL_INCDIRS += $(OPENPITON_IC_VERILOG_RTLDIR)/chipset
MKDV_VL_INCDIRS += $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/axi_sd_bridge/rtl
MKDV_VL_INCDIRS += $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/include
MKDV_VL_INCDIRS += $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/noc_axi4_bridge/rtl
MKDV_VL_INCDIRS += $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/noc_sd_bridge/rtl
MKDV_VL_INCDIRS += $(OPENPITON_IC_VERILOG_RTLDIR)/common/uart/rtl
MKDV_VL_INCDIRS += $(OPENPITON_IC_VERILOG_RTLDIR)/include
MKDV_VL_INCDIRS += $(OPENPITON_IC_VERILOG_RTLDIR)/support

MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/*.v)
#./chip/pll

# TODO:
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/pll/rtl/*.v)

MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/chip_bridge/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/chip_bridge/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/l15/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/l15/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/l15/rtl/sram_wrappers/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/rtap/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/rtap/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/dynamic_node/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/dynamic_node/components/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/dynamic_node/components/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/dynamic_node/parameter/*.v)
#./chip/tile/dynamic_node/synopsys
#./chip/tile/dynamic_node/synopsys/script
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/dynamic_node/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/dynamic_node/common/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/dynamic_node/common/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/dynamic_node/dynamic/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/dynamic_node/dynamic/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/dynamic_node/sim/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/dynamic_node/sim/rtl/*.v)
#./chip/tile/ariane
#./chip/tile/fpu

# TODO:
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/fpu/rtl/*.v)

#./chip/tile/pico
#./chip/tile/pico/rtl
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/rtl/*.v)
#./chip/tile/synopsys
#./chip/tile/synopsys/script
#./chip/tile/common
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/common/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/common/srams/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/common/srams/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/dmbr/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/dmbr/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/l2/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/l2/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/l2/rtl/sram_wrappers/*.v)
#./chip/tile/sparc
#./chip/tile/sparc/exu
#./chip/tile/sparc/exu/bw_r_irf
#./chip/tile/sparc/exu/bw_r_irf/bw_r_irf_register8
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/sparc/exu/bw_r_irf/bw_r_irf_register8/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/sparc/exu/bw_r_irf/rtl/*.v)
#./chip/tile/sparc/exu/bw_r_irf/bw_r_irf_register16
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/sparc/exu/bw_r_irf/bw_r_irf_register16/rtl/*.v)
#./chip/tile/sparc/exu/bw_r_irf/common
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/sparc/exu/bw_r_irf/common/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/sparc/exu/rtl/*.v)
#./chip/tile/sparc/lsu
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/sparc/lsu/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/sparc/rtl/*.v)
#./chip/tile/sparc/tlu
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/sparc/tlu/rtl/*.v)
#./chip/tile/sparc/spu
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/sparc/spu/rtl/*.v)
#./chip/tile/sparc/ffu
#./chip/tile/sparc/ffu/synopsys
#./chip/tile/sparc/ffu/synopsys/script
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/sparc/ffu/rtl/*.v)
#./chip/tile/sparc/ifu
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/sparc/ifu/rtl/*.v)
#./chip/tile/sparc/mul
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/sparc/mul/rtl/*.v)
#./chip/tile/sparc/synopsys
#./chip/tile/sparc/synopsys/script
#./chip/tile/sparc/srams
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/sparc/srams/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/tile/sparc/srams/rtl/sram_wrappers/*.v)

MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/jtag/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/jtag/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/rtl/*.v)
#./chip/synopsys
#./chip/synopsys/script
#./chipset
#./chipset/io_ctrl
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/io_ctrl/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/mc/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/axi_sd_bridge/rtl/*.v)
#./chipset/edk
#./chipset/edk/scripts
#./chipset/noc_axi4_bridge
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/noc_axi4_bridge/rtl/*.v)
#./chipset/noc_sd_bridge
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/noc_sd_bridge/rtl/*.v)
#./chipset/oled
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/oled/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/axi_lite_slave_rf/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/common/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/io_xbar/common/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/io_xbar/dynamic/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/io_xbar/components/rtl/*.v)
#./chipset/io_xbar/parameter
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/io_xbar/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/mem_io_splitter/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/noc_axilite_bridge/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/common/uart_pkttrace_dump/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/common/rtl/*.v)
#./common/fpga_bridge
#./common/fpga_bridge/common
#./common/fpga_bridge/fpga_rcv
#./common/fpga_bridge/fpga_rcv/rtl
#./common/fpga_bridge/rtl
#./common/fpga_bridge/fpga_send
#./common/fpga_bridge/fpga_send/rtl
#./common/uart
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/common/uart/rtl/*.v)
#./include
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/rtl/*.v)
MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/*.v)

MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/support/*.v)

endif

else # Rules

endif