#####
# this is just a hack to reload the module files when they change
import sys
keys=tuple(sys.modules.keys())
for key in keys:
    if ("t0kipona" in key) or ('b0t' in key):
        del sys.modules[key]
import t0kipona as t
import b0t as b
#####

bb = b.TPBot()
