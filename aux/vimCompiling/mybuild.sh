# copy this file to vim/src/ and run it to build with python
# integration, 24 bit true color, with clipboard,
# no gui and x11, no pearl and tcl,
# to start quickly and don't weight when many are open, etc

# x11 is kept to enable the x11 selection (what is it?)
make clean
# ./configure --enable-gui=motif
# ./configure --disable-gui --enable-python3interp --enable-pythoninterp
./configure --enable-python3interp --enable-pythoninterp
./configure --enable-python3interp --enable-pythoninterp --enable-browse --enable-fontset
make config
make
make install

# ToDo
# Make a compiling routine with all GTK, GTK2, kde, motif athena GUIs to test
# sizeof_int etc ok

# build in jan/06/2018
