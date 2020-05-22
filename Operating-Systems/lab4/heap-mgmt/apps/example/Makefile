default:
	cd makeprocs; make
	cd memory_malloc; make

clean:
	cd makeprocs; make clean
	cd memory_malloc; make clean

run:
	cd ../../bin; dlxsim -x os.dlx.obj -a -u makeprocs.dlx.obj 63; ee469_fixterminal;