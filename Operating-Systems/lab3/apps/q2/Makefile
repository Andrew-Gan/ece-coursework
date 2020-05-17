default:
	cd makeprocs; make
	cd inj_CO; make
	cd inj_S2; make
	cd reac_O2_C2; make
	cd reac_S; make
	cd reac_SO4; make

clean:
	cd makeprocs; make clean
	cd inj_CO; make clean
	cd inj_S2; make clean
	cd reac_O2_C2; make clean
	cd reac_S; make clean
	cd reac_SO4; make clean

run:
	cd ../../bin; dlxsim -x os.dlx.obj -a -u makeprocs.dlx.obj 4 8; ee469_fixterminal
