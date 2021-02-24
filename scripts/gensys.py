'''
Created on Feb 18, 2021

@author: mballance
'''

import argparse
import sys
import os
import shutil

# Add a path that can locate the pyhp directory
scripts_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(scripts_dir)

rtl_dir = os.path.abspath(scripts_dir + "/../verilog/rtl")

import pyhp

def getparser():
    parser = argparse.ArgumentParser()
    
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
            
            if ext == ".v" or ext == ".h" or ext == ".vh":
                print("TODO: copy " + srcfile)
                shutil.copy(srcfile, dstfile)
            elif ext == ".pyv":
                dstfile = dstfile[:-4]
                print(">>>: preprocess " + srcfile + " => " + dstfile)
                pyhp.process(
                    srcfile,
                    dstfile)
                print("<<<: preprocess " + srcfile + " => " + dstfile)
                
            pass

def main():
    
    parser = getparser()
    
    args = parser.parse_args()
    
    print("rtl_dir: " + str(rtl_dir))
    
    process_dir(rtl_dir, 
                os.path.join(os.getcwd(), "tmp"))
    
    pass


if __name__ == "__main__":
    main()
    