import sys
keys=tuple(sys.modules.keys())
for key in keys:
    if "tokipona" in key:
        del sys.modules[key]
    if "t" in key:
        del sys.modules[key]
import tokipona as t
