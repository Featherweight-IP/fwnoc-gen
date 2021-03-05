'''
Created on Mar 5, 2021

@author: mballance
'''
from enum import Enum, auto
from typing import Dict


class CacheConfig(object):
    
    def __init__(self, size, associativity, line_size):
        self.size = size
        self.associativity = associativity
        self.line_size = line_size

class NetworkConfig(Enum):
    config_2dmesh = auto()
    config_xbar = auto()
    
            
class TilesConfig(object):
    
    def __init__(self):
        self.x   = -1
        self.y   = -1
        self.num = -1
        self.module = None
        self.network_config = NetworkConfig.config_2dmesh

class DeviceConfig(object):
    
    def __init__(self, name):
        self.name = name
        self.type = None
        self.base = -1
        self.length = -1
        self.noc2in = False
        self.virtual = False
        self.stream_accessible = False
        
class Config(object):
    _active = None
    
    def __init__(self, name):
        self.name = name
        self.l15 = CacheConfig(8192, 4, 16)
        self.l2 = CacheConfig(65536, 4, 64)
        self.tiles = None
        self.devices : Dict[str,DeviceConfig] = {}
        
    @staticmethod
    def active():
        return Config._active

    @staticmethod
    def set_active(cfg):
        Config._active = cfg

