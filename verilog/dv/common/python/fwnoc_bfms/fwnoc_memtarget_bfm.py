'''
Created on Mar 8, 2021

@author: mballance
'''

import pybfms
from fwnoc_bfms.mem_model import MemModel

@pybfms.bfm(hdl={
    pybfms.BfmType.SystemVerilog : pybfms.bfm_hdl_path(__file__, "hdl/fwnoc_memtarget_bfm.v"),
    pybfms.BfmType.Verilog : pybfms.bfm_hdl_path(__file__, "hdl/fwnoc_memtarget_bfm.v")
    }, has_init=True)
class FwNocMemTargetBfm(object):
    
    def __init__(self):
        self.mem = MemModel(32, 64, False)
  
    @pybfms.export_task(pybfms.uint64_t, pybfms.uint64_t)
    def _write8(self, addr, data):
        print("_write8: 0x%08x 0x%08x" % (addr, data))
        addr &= 0x3FFFFFFFF
        self.mem.write_word(addr, 
                            (data & 0xFF)
                            | ((data & 0xFF) << 8)
                            | ((data & 0xFF) << 16)
                            | ((data & 0xFF) << 24)
                            | ((data & 0xFF) << 32)
                            | ((data & 0xFF) << 40)
                            | ((data & 0xFF) << 48)
                            | ((data & 0xFF) << 56),
                            0x80 >> (addr & 0x7))
    
    @pybfms.export_task(pybfms.uint64_t, pybfms.uint64_t)
    def _write16(self, addr, data):
        addr &= 0x3FFFFFFF
        print("_write16: 0x%08x 0x%08x" % (addr, data))
        self.mem.write_word(addr, 
                            (data & 0xFFFF)
                            | ((data & 0xFFFF) << 16)
                            | ((data & 0xFFFF) << 32) 
                            | ((data & 0xFFFF) << 48), 
                            0xC0 >> (addr & 0x6))
    
    @pybfms.export_task(pybfms.uint64_t, pybfms.uint64_t)
    def _write32(self, addr, data):
        addr &= 0x3FFFFFFF
        print("_write32: 0x%08x 0x%08x" % (addr, data))
        self.mem.write_word(addr, 
                            (data & 0xFFFFFFFF) | ((data & 0xFFFFFFFF) << 32), 
                            0xF0 >> (addr & 0x4))
    
    @pybfms.export_task(pybfms.uint64_t, pybfms.uint64_t)
    def _write64(self, addr, data):
        addr &= 0x3FFFFFFF
        print("_write: 0x%08x 0x%08x" % (addr, data))
        self.mem.write_word(addr, data, 0xFF)
    
    @pybfms.export_task(pybfms.uint64_t, pybfms.uint8_t, pybfms.uint8_t)
    def _read_req(self, addr, sz, idx):
        addr &= 0x3FFFFFFF
        word = self.mem.read_word(addr)

        if sz == 1:
            data = ((word >> 8*(addr & 0x7)) & 0xFF)
            word = (
                (data << 56)
                | (data << 48)
                | (data << 40)
                | (data << 32)
                | (data << 24)
                | (data << 16)
                | (data << 8)
                | data)
        elif sz == 2:
            data = ((word >> 8*(addr & 0x6)) & 0xFFFF)
            word = (
                (data << 48)
                | (data << 32)
                | (data << 16)
                | data)
        elif sz == 4:
            data = ((word >> 8*(addr & 0x4)) & 0xFFFFFFFF)
            word = (
                (data << 32)
                | data)
        print("_read_req: 0x%08x 0x%016x" % (addr, word))
        
        self._read_ack(word, idx)
    
    
    @pybfms.import_task(pybfms.uint64_t, pybfms.uint8_t)
    def _read_ack(self, data, idx):
        pass
    