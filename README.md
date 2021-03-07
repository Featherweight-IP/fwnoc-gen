# fwnoc-gen

fwnoc-gen provides a configurable NxM cache-coherent fabric. This 
project is derived from the 
[OpenPiton project](https://parallel.princeton.edu/openpiton), and
makes several changes/improvements:
- Enables just the interconnect (chip) portion to generated
- Adds YAML configuration of the generated interconnect
- Separates generated content from non-generated content
- Adds debug and analysis
- Updates the generator and RTL to support Python3

