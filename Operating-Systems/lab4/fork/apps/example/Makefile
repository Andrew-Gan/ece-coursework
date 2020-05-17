default:
	cd makeprocs; make
	cd hello_world; make

clean:
	cd makeprocs; make clean
	cd hello_world; make clean

one:
	cd ../../bin; dlxsim -x os.dlx.obj -a -u makeprocs.dlx.obj 1; ee469_fixterminal;

five:
	cd ../../bin; dlxsim -x os.dlx.obj -a -u makeprocs.dlx.obj 5; ee469_fixterminal;

ten:
	cd ../../bin; dlxsim -x os.dlx.obj -a -u makeprocs.dlx.obj 10; ee469_fixterminal;