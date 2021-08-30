'''
Created on Mar 12, 2021

@author: mballance
'''
from enum import IntEnum, auto
from fwnoc_dbg_bfms.fwnoc_l2_dbg_bfm import NocMsg, MsgType, MesiBits

class FwNocCachestateBfm(object):
    
    class MsgState(object):
        
        def __init__(self):
            self.mshrid = 0
            self.addr = 0
    
    def __init__(self, linesize=64, ways=4, lines=1024):
        self.cacheset_offset = 6
        self.cacheset_mask = 0xFF
        self.linestate = []

        self.bfms = []
        self.bfm_names = []
        
        for i in range(1024):
            self.linestate.append([MesiBits.Invalid, 0])

    def add_bfm(self, bfm):
        idx = len(self.bfms)
        lb = bfm.bfm_info.inst_name.find(".tile")
        rb = bfm.bfm_info.inst_name.find(".", lb+1)
        bfm_id = int(bfm.bfm_info.inst_name[lb+5:rb])
        print("bfm_id: " + str(bfm_id))
        def recv_msg(msg):
            nonlocal idx
            self._recv_msg(idx, msg)
        self.bfms.append(FwNocCachestateBfm.MsgState())
        self.bfm_names.append(bfm.bfm_info.inst_name)
        bfm.listener = recv_msg
        
    def _recv_msg(self, idx, msg : NocMsg):
        msg_state : FwNocCachestateBfm.MsgState = self.bfms[idx]
        
        if msg.type in [MsgType.LOAD_REQ,MsgType.STORE_REQ,MsgType.LOAD_MEM]:
            # Beginning
            print("Begin: " + hex(msg.addr))
            msg_state.mshrid = msg.mshrid
            msg_state.addr = msg.addr
        elif msg.type in [MsgType.DATA_ACK,MsgType.NODATA_ACK]:
            print("End: 0x%08x dst_x=%d dst_y=%d" % (
                msg_state.addr,
                msg.dst_x,
                msg.dst_y))
            if msg_state.mshrid != msg.mshrid:
                print("Error: mshrid mismatch")
                
            line = ((msg_state.addr >> 6) & 0x3FF)
           
            mesi = msg.get_mesi()
            
            if self.linestate[line][0] != mesi:
#                print("Line: " + hex(line) + " " + str(self.linestate[line][0]) + " => " + str(mesi))
                print("[%s] Line: 0x%08x %s => %s" % (
                    self.bfm_names[idx],
                    int(line), 
                    str(self.linestate[line][0]),
                    str(mesi)))
                self.linestate[line][0] = mesi
            
                
    
        