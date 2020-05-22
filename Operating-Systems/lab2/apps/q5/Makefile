default:
	cd makeprocs; make
	cd inj_H2O; make
	cd inj_SO4; make
	cd reac_H2O; make
	cd reac_H2SO4; make
	cd reac_SO4; make

clean:
	cd makeprocs; make clean
	cd inj_H2O; make clean
	cd inj_SO4; make clean
	cd reac_H2O; make clean
	cd reac_H2SO4; make clean
	cd reac_SO4; make clean

run:
	cd ../../bin; dlxsim -x os.dlx.obj -a -u makeprocs.dlx.obj 3 3; ee469_fixterminal
