default:
	cd ostests; make

clean:
	cd ostests; make clean

debug:
	cd ../../bin; dlxsim -D d -x os.dlx.obj -a -D dF -u ostests.dlx.obj; ee469_fixterminal


run:
	cd ../../bin; dlxsim -x os.dlx.obj -a -D F -u ostests.dlx.obj; ee469_fixterminal
