'''
Created on Mar 8, 2021

@author: mballance
'''
import pybfms
from typing import List
from enum import IntEnum

class MesiBits(IntEnum):
    Invalid   = 0
    Shared    = 1
    Exclusive = 2
    Modified  = 3
    
class MsgType(IntEnum):
    RESERVED = 0
    LOAD_REQ = 31
    PREFETCH_REQ = 1
    STORE_REQ = 2
    BLK_STORE_REQ = 3
    BLKINIT_STORE_REQ = 4
    CAS_REQ = 5
    CAS_P1_REQ = 6
    CAS_P2Y_REQ = 7
    CAS_P2N_REQ = 8
    SWAP_REQ = 9
    SWAP_P1_REQ = 10
    SWAP_P2_REQ = 11
    WB_REQ = 12
    WBGUARD_REQ = 13
    NC_LOAD_REQ = 14
    NC_STORE_REQ = 15
    INTERRUPT_FWD = 32
    
    AMO_ADD_REQ = 36
    AMO_AND_REQ = 37
    AMO_OR_REQ  = 38
    AMO_XOR_REQ = 39
    AMO_MAX_REQ = 40
    AMO_MAXU_REQ = 41
    AMO_MIN_REQ = 42
    AMO_MINU_REQ = 43
    
    AMO_ADD_P1_REQ = 44
    AMO_AND_P1_REQ = 45
    AMO_OR_P1_REQ  = 46
    AMO_XOR_P1_REQ = 47
    AMO_MAX_P1_REQ = 48
    AMO_MAXU_P1_REQ = 49
    AMO_MIN_P1_REQ = 50
    AMO_MINU_P1_REQ = 51
    
    AMO_ADD_P2_REQ = 52
    AMO_AND_P2_REQ = 53
    AMO_OR_P2_REQ  = 54
    AMO_XOR_P2_REQ = 55
    AMO_MAX_P2_REQ = 56
    AMO_MAXU_P2_REQ = 57
    AMO_MIN_P2_REQ = 58
    AMO_MINU_P2_REQ = 59
    
    LR_REQ = 60
    
    # L2->L15
    LOAD_FWD = 16
    STORE_FWD = 17
    INV_FWD = 18
    
    # L2->DRAM
    LOAD_MEM = 19
    STORE_MEM = 20
    
    # L15->L2 forward acks
    LOAD_FWDACK = 21
    STORE_FWDACK = 22
    INV_FWDACK = 23
    
    # Acks from DRAM -> L2
    LOAD_MEM_ACK = 24
    STORE_MEM_ACK = 25
    NC_LOAD_MEM_ACK = 26
    NC_STORE_MEM_ACK = 27

    # Acks from L2 -> L15
    NODATA_ACK = 28
    DATA_ACK = 29
    
    ERROR = 30
    INTERRUPT = 33
    
    L2_LINE_FLUSH_REQ = 34
    L2_DIS_FLUSH_REQ = 35
    

class NocMsg(object):
    
    def __init__(self, noc_hdr : List[int]):
        header = noc_hdr[0]
        header <<= 64
        header |= noc_hdr[1]
        header <<= 64
        header |= noc_hdr[2]
        
        print("msg: header=0x%08x" % header)
        
#         self.last_subline = (header & 1)
#         self.subline_id   = ((header >> 1) & 0x3)
#         self.l2_miss      = ((header >> 3) & 1)
#         self.mesi         = ((header >> 4) & 0x3)
#         self.mshrid       = ((header >> 6) & 0xFF)
#         self.type         = ((header >> 14) & 0xFF)
#         self.length       = ((header >> 22) & 0xFF)
#         self.dst_fbits    = ((header >> 30) & 0x0F)
#         self.dst_y        = ((header >> 34) & 0xFF)
#         self.dst_x        = ((header >> 42) & 0xFF)
#         self.dst_chipid   = ((header >> 50) & 0x3FFF)
#         self.data_size    = ((header >> 72) & 0x07)
#         self.cache_type   = ((header >> 75) & 0x01)
#         self.subline_vect = ((header >> 75) & 0x07)
#         # 39-bit address
#         self.addr         = ((header >> 80) & 0x7FFFFFFFF)
#         self.lsid         = ((header >> 142) & 0x0F)
#         self.sdid         = ((header >> 148) & 0x3FF)
#         self.src_fbits    = ((header >> 158) & 0x0F)
#         self.src_x        = ((header >> 162) & 0xFF)
#         self.src_y        = ((header >> 170) & 0xFF)
#         self.src_chipid   = ((header >> 178) & 0x3FFF)

        # `define MSG_LAST_SUBLINE        0
        # `define MSG_SUBLINE_ID          2:1
        # `define MSG_L2_MISS             3
        # `define MSG_MESI                5:4
        # `define MSG_OPTIONS_1           5:0
        # `define MSG_OPTIONS_4           5:0
        # `define MSG_MSHRID              13:6
        # `define MSG_TYPE                21:14
        # `define MSG_TYPE_LO             14
        # `define MSG_LENGTH              29:22
        # `define MSG_LENGTH_LO           22
        # `define MSG_DST_FBITS           33:30
        # `define MSG_DST_Y               41:34
        # `define MSG_DST_X               49:42
        # `define MSG_DST_CHIPID          63:50
        # `define MSG_DST_CHIPID_HI       63

        self.dst_chipid     = ((noc_hdr[0] >> 50) & 0x3FFF)
        self.dst_x          = ((noc_hdr[0] >> 42) & 0xFF)
        self.dst_y          = ((noc_hdr[0] >> 34) & 0xFF)
        self.dst_fbits      = ((noc_hdr[0] >> 30) & 0x0F)
        self.length         = ((noc_hdr[0] >> 22) & 0xFF)
        self.type           = ((noc_hdr[0] >> 14) & 0xFF)
        self.mshrid         = ((noc_hdr[0] >> 6) & 0xFF)
        self.mesi           = ((noc_hdr[0] >> 4) & 0x03)
        self.l2_miss        = ((noc_hdr[0] >> 3) & 0x01)

        # `define MSG_DATA_SIZE           74:72
        # `define MSG_CACHE_TYPE          75
        # `define MSG_SUBLINE_VECTOR      79:76
        # `define MSG_ADDR                119:80
        self.addr         = ((noc_hdr[1] >> 16) & 0x7FFFFFFFF)
        self.data_size    = ((noc_hdr[1] >> 8) & 0x7)

        # `define MSG_LSID_                19:14 // 147-128:142-128
        # `define MSG_SDID_                29:20
        # `define MSG_OPTIONS_3_           29:0
        # `define MSG_SRC_FBITS_           33:30
        # `define MSG_SRC_Y_               41:34
        # `define MSG_SRC_X_               49:42
        # `define MSG_SRC_CHIPID_          63:50
        self.src_chipid   = ((noc_hdr[2] >> 50) & 0x3FFF)
        self.src_y        = ((noc_hdr[2] >> 42) & 0xFF)
        self.src_x        = ((noc_hdr[2] >> 34) & 0xFF)
        self.src_fbits    = ((noc_hdr[2] >> 30) & 0x0F)
        
        self.data = [noc_hdr[1], noc_hdr[2]]
        
    def get_type(self):
        if self.type in MsgType._value2member_map_:
            return MsgType(self.type)
        else:
            return None
        
    def get_mesi(self):
        if self.mesi in MesiBits._value2member_map_:
            return MesiBits(self.mesi)
        else:
            return None
        

@pybfms.bfm(hdl={
    pybfms.BfmType.Verilog : pybfms.bfm_hdl_path(__file__, "hdl/fwnoc_l2_dbg_bfm.v"),
    pybfms.BfmType.SystemVerilog : pybfms.bfm_hdl_path(__file__, "hdl/fwnoc_l2_dbg_bfm.v")
    }, has_init=True)
class FwNocL2DbgBfm(object):
    
    def __init__(self):
        self.headers = {}
        self.msgs = {}
        self.listener = None
        pass

    @pybfms.export_task(pybfms.uint8_t, pybfms.uint64_t)
    def _recv_data(self, noc, data):
        print("%s [%d]: recv_data 0x%016x" % (self.bfm_info.inst_name, noc, data))
        if noc in self.msgs.keys():
            self.msgs[noc].data.append(data)
            
            if self.msgs[noc].length == len(self.msgs[noc].data):
                if self.listener is not None:
                    self.listener(self.msgs[noc])
                del self.msgs[noc]
                
            pass
        else:
            # Accepting the header
            if not noc in self.headers.keys():
                self.headers[noc] = []
            noc_hdr = self.headers[noc]
            
            noc_hdr.append(data)
            if len(noc_hdr) == 3:
                msg = NocMsg(noc_hdr)
                
                print("  %s [%d] type=%s address=0x%08x mshrid=%d length=%d data_size=%d mesi=%s (%d,%d) => (%d,%d)" % (
                    self.bfm_info.inst_name, 
                    noc, str(msg.get_type()), 
                    msg.addr, msg.mshrid, msg.length, msg.data_size, str(msg.get_mesi()),
                    msg.src_x,
                    msg.src_y,
                    msg.dst_x,
                    msg.dst_y))
                
                if msg.length <= 2:
                    if self.listener is not None:
                        self.listener(msg)
                else:
                    self.msgs[noc] = msg
                noc_hdr.clear()
        pass
    