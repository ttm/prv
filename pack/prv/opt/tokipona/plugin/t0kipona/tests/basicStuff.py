import sys
keys=tuple(sys.modules.keys())
for key in keys:
    if "t0kipona" in key:
        del sys.modules[key]
import t0kipona as t
