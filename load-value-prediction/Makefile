ARCH=X86
BENCHMARK_TEST=cam4_s #cactuBSSN_s #cam4_s #nab_s #xz_s
CPU_TYPE=O3CPU
CACHE_CONFIG=--mem-size=8192MB --l1d_size=64kB --l1i_size=16kB --caches --l2cache
DEBUG_FLG=LVP,ExecAll,Commit#Decoder #LVP #O3PipeView #O3CPUAll
DEBUG_OUT=trace2.out
MAX_INST=10000000
VARIANT=opt #debug #opt #fast

SHELL := /bin/bash

make:
	scons-3 USE_HDF5=0 -j `nproc` ./build/ECE565-$(ARCH)/gem5.$(VARIANT)

run:
	./build/ECE565-X86/gem5.$(VARIANT) configs/spec/spec_se.py --cpu-type=$(CPU_TYPE) --maxinsts=$(MAX_INST) $(CACHE_CONFIG) -b $(BENCHMARK_TEST)

debug:
	./build/ECE565-X86/gem5.$(VARIANT) --debug-flags=$(DEBUG_FLG) --debug-file=$(DEBUG_OUT) configs/spec/spec_se.py --cpu-type=$(CPU_TYPE) --maxinsts=$(MAX_INST) $(CACHE_CONFIG) -b $(BENCHMARK_TEST)

gdb:
	gdb ./build/ECE565-X86/gem5.$(VARIANT)

view:
	./util/o3-pipeview.py -c 500 -o pipeview.out --color m5out/$(DEBUG_OUT)
	less -r pipeview.out

clean:
	rm -rf pipeview.out m5out/$(DEBUG_OUT) benchmark_files*
