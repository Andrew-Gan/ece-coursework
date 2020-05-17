default:
	cd makeprocs; make
	cd q2_p1; make
	cd q2_p2; make
	cd q2_p3; make
	cd q2_p4; make
	cd q2_p6; make

clean:
	cd makeprocs; make clean
	cd q2_p1; make clean
	cd q2_p2; make clean
	cd q2_p3; make clean
	cd q2_p4; make clean
	cd q2_p6; make clean

run:
	cd ../../bin; dlxsim -x os.dlx.obj -a -u makeprocs.dlx.obj 0; ee469_fixterminal;

a:
	cd ../../bin; dlxsim  -x os.dlx.obj -a  -u makeprocs.dlx.obj 1; ee469_fixterminal;

b:
	cd ../../bin; dlxsim  -x os.dlx.obj -a  -u makeprocs.dlx.obj 2; ee469_fixterminal;

c:
	cd ../../bin; dlxsim  -x os.dlx.obj -a -u makeprocs.dlx.obj 3; ee469_fixterminal;

d:
	cd ../../bin; dlxsim  -D d -x os.dlx.obj -a -D d -u makeprocs.dlx.obj 4; ee469_fixterminal;

e:
	cd ../../bin; dlxsim  -D d -x os.dlx.obj -a -D d -u makeprocs.dlx.obj 5; ee469_fixterminal;

f:
	cd ../../bin; dlxsim  -x os.dlx.obj -a  -u makeprocs.dlx.obj 6; ee469_fixterminal;
