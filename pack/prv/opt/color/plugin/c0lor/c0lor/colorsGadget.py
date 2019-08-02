import os

os.system(r"printf '\e]4;1;rgb:FF/00/00\e\\\\\e[31m██ = #FF0000\e[m\n'")


def printColor(c='#FF00AA'):

    p = ''
    c = '█'
    for i in range(10000):
        p += ' ' + c*(i+1)
    os.system(r"printf '\e]4;1;rgb:{}/{}/{}\e\\\e[31m{}= c\e[m\n'".format(c[1:3],c[3:5],c[5:7],p,c))
