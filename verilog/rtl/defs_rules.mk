OPENPITON_IC_VERILOG_RTLDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

ifneq (1,$(RULES))

ifeq (,$(findstring $(OPENPITON_IC_VERILOG_RTLDIR),$(MKDV_INCLUDED_DEFS)))
MKDV_INCLUDED_DEFS += $(OPENPITON_IC_VERILOG_RTLDIR)
MKDV_VL_INCDIRS += $(OPENPITON_IC_VERILOG_RTLDIR)/chipset
MKDV_VL_INCDIRS += $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/axi_sd_bridge/rtl
MKDV_VL_INCDIRS += $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/include
MKDV_VL_INCDIRS += $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/noc_axi4_bridge/rtl
MKDV_VL_INCDIRS += $(OPENPITON_IC_VERILOG_RTLDIR)/chipset/noc_sd_bridge/rtl
MKDV_VL_INCDIRS += $(OPENPITON_IC_VERILOG_RTLDIR)/common/uart/rtl
MKDV_VL_INCDIRS += $(OPENPITON_IC_VERILOG_RTLDIR)/include

MKDV_VL_SRCS += $(wildcard $(OPENPITON_IC_VERILOG_RTLDIR)/chip/*.v)
#./chip/pll
#./chip/pll/rtl
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
#./chip/tile/fpu/rtl
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
#./chip/tile/sparc/exu/bw_r_irf/bw_r_irf_register8/rtl
#./chip/tile/sparc/exu/bw_r_irf/rtl
#./chip/tile/sparc/exu/bw_r_irf/bw_r_irf_register16
#./chip/tile/sparc/exu/bw_r_irf/bw_r_irf_register16/rtl
#./chip/tile/sparc/exu/bw_r_irf/common
#./chip/tile/sparc/exu/bw_r_irf/common/rtl
#./chip/tile/sparc/exu/rtl
#./chip/tile/sparc/lsu
#./chip/tile/sparc/lsu/rtl
#./chip/tile/sparc/rtl
#./chip/tile/sparc/tlu
#./chip/tile/sparc/tlu/rtl
#./chip/tile/sparc/spu
#./chip/tile/sparc/spu/rtl
#./chip/tile/sparc/ffu
#./chip/tile/sparc/ffu/synopsys
#./chip/tile/sparc/ffu/synopsys/script
#./chip/tile/sparc/ffu/rtl
#./chip/tile/sparc/ifu
#./chip/tile/sparc/ifu/rtl
#./chip/tile/sparc/mul
#./chip/tile/sparc/mul/rtl
#./chip/tile/sparc/synopsys
#./chip/tile/sparc/synopsys/script
#./chip/tile/sparc/srams
#./chip/tile/sparc/srams/rtl
#./chip/tile/sparc/srams/rtl/sram_wrappers
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

endif

else # Rules

endif