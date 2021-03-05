'''
Created on Mar 5, 2021

@author: mballance
'''

import yaml
from typing import List, Tuple
from pyhp.config import Config, NetworkConfig, TilesConfig, DeviceConfig
from termios import CIBAUD


class ConfigParser(object):
    
    def __init__(self):
        self.config = None
        
    def parse(self, path) -> List[Tuple[str,Config]]:
        
        ret = []
        
        with open(path, "r") as f:
            doc = yaml.load(f, Loader=yaml.FullLoader)
            
        for key in doc.keys():
            # Each key represents a configuration
            config = self.parse_config(key, doc[key])
            
            ret.append((key,config))
            
        return ret
    
    def parse_config(self, name, cfg_data):
        
        cfg = Config(name)

        for section in cfg_data:
            key = next(iter(section.keys()))
            
            if key == "interconnect":
                self.parse_interconnect_config(
                    cfg,
                    section[key])
            elif key == "devices":
                self.parse_devices_config(
                    cfg,
                    section[key])
            else:
                raise Exception("Unknown section \"" + key + "\"")
            
        return cfg
            
    def parse_interconnect_config(self,
                    cfg : Config,
                    cfg_data):
        for section in cfg_data:
            key =next(iter(section.keys()))
            if key == "cache":
                self.parse_cache_config(
                    cfg,
                    section[key])
            elif key == "tiles":
                self.parse_tile_config(cfg, section[key])
            else:
                raise Exception("Unknown interconnect section " + key + "")

    def parse_cache_config(self,
                    cfg : Config,
                    cfg_data):
        for section in cfg_data:
            key = next(iter(section.keys()))
            
            cc = None
            if key == "l15":
                cc = cfg.l15
            elif key == "l2":
                cc = cfg.l2
            else:
                raise Exception("Unknown cache level " + key + "")

            for subs in section[key]:
                ci = next(iter(subs.keys()))            
                
                if ci == "size":
                    cc.size = int(subs[ci])
                elif ci == "associativity":
                    cc.associativity = int(subs[ci])
                elif ci == "line-size":
                    cc.line_size = int(subs[ci])
                else:
                    raise Exception("Unknown cache parameter " + ci + "")

    def parse_tile_config(self,
                    cfg : Config,
                    cfg_data):

        tiles = TilesConfig()
        
        for section in cfg_data:
            key = next(iter(section.keys()))
            
            if key == "x":
                tiles.x = int(section[key])
            elif key == "y":
                tiles.y = int(section[key])
            elif key == "num":
                tiles.num = int(section[key])
            elif key == "network-config":
#                network_config = 
                pass
            elif key == "module":
                tiles.module = section[key]
            else:
                raise Exception("Unknown tiles parameter " + key + "")

        if tiles.x == -1:
            raise Exception("'x' dimension not specified")
        if tiles.y == -1:
            raise Exception("'y' dimension not specified")
        
        if tiles.num == -1:
            tiles.num = tiles.x * tiles.y
            
        cfg.tiles = tiles
            
    def parse_devices_config(self,
                    cfg : Config,
                    cfg_data):
        
        for section in cfg_data:
            key = next(iter(section.keys()))
            dev = DeviceConfig(key)

            for subs in section[key]:
                ci = next(iter(subs.keys()))
                
                if ci == "base":
                    dev.base = int(subs[ci])
                elif ci == "length":
                    dev.length = int(subs[ci])
                elif ci == "noc2in":
                    dev.noc2in = bool(subs[ci])
                elif ci == "virtual":
                    dev.virtual = bool(subs[ci])
                elif ci == "stream-accessible":
                    dev.stream_accessible = bool(subs[ci])
                
            cfg.devices[key] = dev
    

            

    