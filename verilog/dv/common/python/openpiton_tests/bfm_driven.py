'''
Created on Mar 5, 2021

@author: mballance
'''

from typing import List

import cocotb
import pybfms
from rv_bfms.rv_addr_line_en_initiator_bfm import RvAddrLineEnInitiatorBfm
from fwnoc_dbg_bfms.fwnoc_cachestate_bfm import FwNocCachestateBfm
from fwnoc_dbg_bfms.fwnoc_l2_dbg_bfm import FwNocL2DbgBfm
import random

async def ensure_exclusive(bfm, cacheset):
#    cacheset = (line >> 6) & 0xFF
    tag = random.randrange(0x0000,0xFFFF)
    
    # Perform 5 reads to ensure we go exclusive
    await bfm.read(
        ((tag+1) << 14)
        | (cacheset << 6))

    await bfm.read(
        ((tag+2) << 14)
        | (cacheset << 6))
    await bfm.read(
        ((tag+3) << 14)
        | (cacheset << 6))
    await bfm.read(
        ((tag+4) << 14)
        | (cacheset << 6))
    await bfm.read(
        (tag << 14)
        | (cacheset << 6))

async def ensure_modified(bfm, cacheset):
    tag = random.randrange(0x0000,0xFFFF)
    for i in range(4):
        data = random.randrange(0x00000000,0xFFFFFFFF)
        await bfm.write(
            (tag+i << 14)
            | (cacheset << 6), data)
        
async def ensure_shared(bfm1, bfm2, cacheset):
    tag = random.randrange(0x0000,0xFFFF)
    
    # First, ensure is exclusive
    print("--> [%s] Read(4)" % bfm1.bfm_info.inst_name)
    for i in range(4):
        await bfm1.read(
            (tag+i << 14)
            | (cacheset << 6))
    print("<-- [%s] Read(4)" % bfm1.bfm_info.inst_name)
        
    print("--> [%s] Read(1)" % bfm2.bfm_info.inst_name)
    await bfm2.read(
        (tag << 14)
        | (cacheset << 6))
    print("<-- [%s] Read(1)" % bfm2.bfm_info.inst_name)

@cocotb.test()
async def test(dut):
    await pybfms.init()
    
    cachestate_bfm = FwNocCachestateBfm()
    
    bfms : List[RvAddrLineEnInitiatorBfm] = pybfms.find_bfms(".*u_dut.*", RvAddrLineEnInitiatorBfm)
    
#        bank_bfms = pybfms.find_bfms(".*bank_bfm.*", GpioBfm)
#        for i,b in enumerate(bank_bfms):
#            lb = b.bfm_info.inst_name.rfind("[")
#            rb = b.bfm_info.inst_name.rfind("]")
#            idx = int(b.bfm_info.inst_name[lb+1:rb])
#            bank_bfms[i] = (idx,b)
#            print("Bank BFM: " + b.bfm_info.inst_name + " " + str(idx))
            
#        bank_bfms.sort(key=lambda e : e[0])
#        self.bank_bfms : List[GpioBfm] = list(map(lambda e : e[1], bank_bfms))    

    for i,b in enumerate(bfms):
        print("Bfm: " + b.bfm_info.inst_name)
        lb = b.bfm_info.inst_name.find(".tile")
        rb = b.bfm_info.inst_name.find(".", lb+1)
        idx = int(b.bfm_info.inst_name[lb+5:rb])
        bfms[i] = (idx,b)

        print("tile: " + b.bfm_info.inst_name[lb:rb] + " idx: " + str(idx))
    bfms.sort(key=lambda e : e[0])
    bfms = list(map(lambda e : e[1], bfms))
    
    for b in pybfms.find_bfms(".*u_dbg_bufroute", FwNocL2DbgBfm):
        cachestate_bfm.add_bfm(b)
        
    
#    await cocotb.triggers.Timer(100, "us")

    for i in range(1000):
        scenario = random.randrange(0,255) % 3
#        scenario = 2
        cacheset = random.randrange(0,255)
        
        if scenario == 0: # make-exclusive
            bfm_id = random.randrange(1,3)
            print("--> Scenario: Make Exclusive " + hex(cacheset) + " bfm " + str(bfm_id))
            await ensure_exclusive(bfms[bfm_id], cacheset)
            print("<-- Scenario: Make Exclusive " + hex(cacheset) + " bfm " + str(bfm_id))
        elif scenario == 1: # ensure_modified
            bfm_id = random.randrange(1,3)
            print("--> Scenario: Make Modified " + hex(cacheset) + " bfm " + str(bfm_id))
            await ensure_modified(bfms[bfm_id], cacheset)
            print("<-- Scenario: Make Modified " + hex(cacheset) + " bfm " + str(bfm_id))
        elif scenario == 2: # ensure_shared
            bfm1_id = random.randrange(1,3)
            bfm2_id = random.randrange(1,3)
            
            while bfm1_id == bfm2_id:
                bfm2_id = random.randrange(1,3)
                
            print("--> Scenario: Make Shared " + hex(cacheset) + " bfm " + str(bfm1_id) + " bfm " + str(bfm2_id))
            await ensure_shared(bfms[bfm1_id], bfms[bfm2_id], cacheset)
            print("<-- Scenario: Make Shared " + hex(cacheset) + " bfm " + str(bfm1_id) + " bfm " + str(bfm2_id))
        else:
            print("Error: scenario " + str(scenario))
            

#     # Write by one core ; Read by another
#     tag = 0
#     cacheset = 0
#     addr = (tag << 14) | (cacheset << 6)
#     print("--> Write C0")
#     for i in range(16):
#         v = i+1
#         await bfms[0].write(addr + 4*i, v|(v<<8)|(v<<16)|(v<<24))
#     print("<-- Write C0")
# 
#     print("--> Read C1")
#     addr = (tag << 14) | (cacheset << 6)
#     for i in range(16):
#         v = i+1
#         data = await bfms[1].read(addr + 4*i)
#         print("data @ 0x%08x: 0x%08x" % (addr+4*i, data))
#     print("<-- Read C1")
# 
#     cacheset = 1
#     addr = (tag << 14) | (cacheset << 6)
#     print("--> Write C0(2)")
#     for i in range(16):
#         v = i+1
#         await bfms[0].write(0x80000000 | (addr + 4*i), v|(v<<8)|(v<<16)|(v<<24))
#     print("<-- Write C0(2)")
# 
#     print("--> Read C1(2)")
#     addr = (tag << 14) | (cacheset << 6)
#     for i in range(16):
#         v = i+1
#         data = await bfms[1].read(addr + 4*i)
#         print("data @ 0x%08x: 0x%08x" % (addr+4*i, data))
#     print("<-- Read C1(2)")
#     
#     print("--> Read C2(2)")
#     addr = (tag << 14) | (cacheset << 6)
#     for i in range(16):
#         v = i+1
#         data = await bfms[2].read(addr + 4*i)
#         print("data @ 0x%08x: 0x%08x" % (addr+4*i, data))
#     print("<-- Read C2(2)")
#     
#     print("--> Write C2(2)")
#     addr = (tag << 14) | (cacheset << 6)
#     for i in range(16):
#         v = i+2
#         await bfms[0].write(addr + 4*i, v|(v<<8)|(v<<16)|(v<<24))
#     print("<-- Read C2(2)")
# 
#     print("--> Evict dirty")
#     tag += 1
#     addr = (tag << 14) | (cacheset << 6)
#     data = await bfms[2].read(addr + 4*i)
#     tag += 1
#     addr = (tag << 14) | (cacheset << 6)
#     data = await bfms[2].read(addr + 4*i)
#     tag += 1
#     addr = (tag << 14) | (cacheset << 6)
#     data = await bfms[2].read(addr + 4*i)
#     tag += 1
#     addr = (tag << 14) | (cacheset << 6)
#     data = await bfms[2].read(addr + 4*i)
#     print("<-- Evict dirty")
        
    # Use uncached writes to directly write to memory
#     for i in range(8):
#         print("data: (w) 0x%08x: 0x%08x" % (0x80001000+4*i, 0x55eeaaff+i))
# #        await bfms[0].write(0x80001000 + 4*i, 0x55eeaaff+i)
#         v = i+1
#         await bfms[0].write(0x80001000 + 4*i, v|(v<<8)|(v<<16)|(v<<24))
#     
#     print("--> READ(1)(1)")
#     data = await bfms[0].read(0x00001000)
#     data = await bfms[0].read(0x00001004)
#     data = await bfms[0].read(0x00001008)
#     print("<-- READ(1)(1)")
#     print("--> READ(1)(2)")
#     data = await bfms[1].read(0x00001010)
#     print("<-- READ(1)(2)")
#     print("--> READ(1)(3)")
#     data = await bfms[2].read(0x00001010)
#     print("<-- READ(1)(3)")
#     print("--> WRITE(1)(1)")
#     await bfms[0].write(0x00001000, 5)
#     print("<-- WRITE(1)(1)")
#     print("--> WRITE(1)(2)")
#     await bfms[1].write(0x00001004, 7)
#     print("<-- WRITE(1)(2)")
#     print("--> READ(2)(1)")
#     data = await bfms[0].read(0x00001000)
#     print("<-- READ(2)(1)")
#     print("--> READ(2)(2)")
#     data = await bfms[1].read(0x00001004)
#     print("<-- READ(2)(2)")

#     for i in range(4):
#         print("--> READ(0)[%d]" % i)
#         data = await bfms[i].read(0x00001000)
#         print("<-- READ(0)[%d] 0x%08x" % (i,data))
#          
#     for i in range(4):
#         print("--> READ(1)[%d]" % i)
#         data = await bfms[i].read(0x00001004)
#         print("<-- READ(1)[%d] 0x%08x" % (i,data))
#          
#     for i in range(4):
#         print("--> READ(2)[%d]" % i)
#         data = await bfms[i].read(0x00001008)
#         print("<-- READ(2)[%d] 0x%08x" % (i,data))
#         
#     for i in range(4):
#         print("--> READ(3)[%d]" % i)
#         data = await bfms[i].read(0x0000100C)
#         print("<-- READ(3)[%d] 0x%08x" % (i,data))
       
#     print("--> READ(1)")
#     data = await bfms[1].read(0x80001004)
#     print("<-- READ(1) " + hex(data))
#     print("--> READ(2)")
#     data = await bfms[2].read(0x80001008)
#     print("<-- READ(2) " + hex(data))
#     print("--> READ(3)")
#     data = await bfms[3].read(0x8000100C)
#     print("<-- READ(3) " + hex(data))
    
#    for j in range(100):    
#        for i in range(64):
            #        await bfms[0].write(0x80000000 + 4*i, 0x55eeaaff)
#            await bfms[0].read(0x80001000 + 4*i)
#            await bfms[0].write(0x80002000 + 4*i, 0x55eeaaff)
#            await bfms[0].read(0x00001000 + 4*i)
#            await bfms[2].read(0x00001000 + 4*i)
#            await bfms[3].read(0x00001000 + 4*i)
#            await bfms[0].write(0x00001000 + 4*i, 0x55eeaaff)
#            await bfms[0].read(0x00001000 + 4*i)
            #        await cocotb.triggers.Timer(1, "us")
        
