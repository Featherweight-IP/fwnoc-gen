'''
Created on Mar 5, 2021

@author: mballance
'''

from typing import List

import cocotb
import pybfms
from rv_bfms.rv_addr_line_en_initiator_bfm import RvAddrLineEnInitiatorBfm


@cocotb.test()
async def test(dut):
    await pybfms.init()
    
    bfms : List[RvAddrLineEnInitiatorBfm] = pybfms.find_bfms(".*u_dut.*", RvAddrLineEnInitiatorBfm)

    print("bfms: " + str(bfms))
    
#    await cocotb.triggers.Timer(100, "us")

    for i in range(64):
        await bfms[0].write(0x80001000 + 4*i, 0x55eeaaff+i)

    for j in range(100):    
        for i in range(64):
            print("--> read (" + str(i) + ")")
            #        await bfms[0].write(0x80000000 + 4*i, 0x55eeaaff)
#            await bfms[0].read(0x80001000 + 4*i)
#            await bfms[0].write(0x80002000 + 4*i, 0x55eeaaff)
            await bfms[0].read(0x00001000 + 4*i)
            await bfms[1].read(0x00001000 + 4*i)
            await bfms[2].read(0x00001000 + 4*i)
            await bfms[3].read(0x00001000 + 4*i)
#            await bfms[0].write(0x00001000 + 4*i, 0x55eeaaff)
#            await bfms[0].read(0x00001000 + 4*i)
            #        await cocotb.triggers.Timer(1, "us")
            print("<-- read (" + str(i) + ")")
        
