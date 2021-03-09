'''
Created on Feb 18, 2021

@author: mballance
'''

import argparse
import os
import shutil
import sys

import pyhp
from pyhp.config import Config
from pyhp.config_parser import ConfigParser
# from pyhp.pyhplib import X_TILES, NUM_TILES, CONFIG_L15_SIZE,\
#     CONFIG_L15_ASSOCIATIVITY, CONFIG_L2_SIZE, CONFIG_L2_ASSOCIATIVITY, Y_TILES,\
#     L15_LINE_SIZE, L2_LINE_SIZE



# Add a path that can locate the pyhp directory
scripts_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(scripts_dir)

rtl_dir = os.path.abspath(scripts_dir + "/../verilog/rtl")

VERBOSE = 0


def getparser():
    parser = argparse.ArgumentParser()
    
    parser.add_argument("-o", dest="out", default="outdir")
    parser.add_argument("config", help="YAML configuration file")
    
    return parser

def process_dir(src_path, dst_path):
    
    if not os.path.isdir(dst_path):
        os.makedirs(dst_path)
    
    for d in os.listdir(src_path):
#        print("d=" + d)
        if d != "." and d != ".." and os.path.isdir(os.path.join(src_path, d)):
            process_dir(
                os.path.join(src_path, d),
                os.path.join(dst_path, d))
        else:
            srcfile = os.path.join(src_path, d)
            dstfile = os.path.join(dst_path, d)
            ext = os.path.splitext(srcfile)[1]
            
            if ext == ".v" or ext == ".h" or ext == ".vh" or ext == ".mk":
                if VERBOSE:
                    print("Note: copy " + srcfile)
#                shutil.copy(srcfile, dstfile)
            elif ext == ".pyv":
                dstfile = dstfile[:-4]
                if VERBOSE > 1:
                    print(">>>: preprocess " + srcfile + " => " + dstfile)
                pyhp.process(
                    srcfile,
                    dstfile)
                if VERBOSE > 1:
                    print("<<<: preprocess " + srcfile + " => " + dstfile)
                
            pass

def main():
    global X_TILES, Y_TILES, NUM_TILES
    global CONFIG_L15_SIZE, CONFIG_L15_ASSOCIATIVITY
    global CONFIG_L2_SIZE, CONFIG_L2_ASSOCIATIVITY
    global L15_LINE_SIZE, L2_LINE_SIZE
    global ACTIVE_CONFIG
    
    parser = getparser()
    
    args = parser.parse_args()
    
    print("rtl_dir: " + str(rtl_dir))
    
    outdir = os.path.abspath(args.out)
    
    print("outdir=" + str(outdir))
    
    config_l = ConfigParser().parse(args.config)

    Config.set_active(config_l[0][1])
    
#     X_TILES = config.tiles.x
#     Y_TILES = config.tiles.y
#     NUM_TILES = config.tiles.num
#     
#     CONFIG_L15_SIZE = config.l15.size
#     CONFIG_L15_ASSOCIATIVITY = config.l15.associativity
#     L15_LINE_SIZE = config.l15.line_size
#     
#     CONFIG_L2_SIZE = config.l2.size
#     CONFIG_L2_ASSOCIATIVITY = config.l2.associativity
#     L2_LINE_SIZE = config.l2.line_size
    
    process_dir(rtl_dir, outdir)
    
    pass


if __name__ == "__main__":
    main()
    