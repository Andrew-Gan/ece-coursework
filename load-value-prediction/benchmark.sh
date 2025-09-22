#/bin/bash

for config_type in "simple" "constant" "limit" "perfect"
do
    cp ./benchmark_configs/${config_type}.hh ./src/cpu/o3/cpu.hh
    make make
    for benchmark_name in  "leela_s" "exchange2_s" "roms_s" 
        do
            for num_inst in "1000000" "10000000" "100000000" #Run 1M, 10M, 100M
                do
                    ./build/ECE565-X86/gem5.opt --outdir=benchmark_files_2/${benchmark_name}_${config_type}_${num_inst} configs/spec/spec_se.py --cpu-type=O3CPU --maxinsts=${num_inst} --mem-size=8192MB --l1d_size=64kB --l1i_size=16kB --caches --l2cache -b ${benchmark_name} &

                done
        done
done
wait
echo "finished all tests"
