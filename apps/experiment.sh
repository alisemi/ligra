#!/bin/bash

applications=("BFS" "PageRankDelta")
graphs=("../inputs/soc-liveJournal/soc-LiveJournal1_ligra" "../inputs/soc-pokec/soc-pokec-relationships_ligra")
graphs_names=("soc-LiveJournal1" "soc-pokec")

for (( counter=0; counter<${#applications[@]}; counter++ ));
do
    for (( counter2=0; counter2<${#graphs[@]}; counter2++ ));
    do
        # Branch misses
        perf stat -x, -e branch-instructions,branch-misses --all-user -o results_${applications[$counter]}_${graphs_names[$counter2]}_branchs ./${applications[$counter]} -rounds 1 ${graphs[$counter2]}
        
        # Cycles
        perf stat -x, -e cycles,ref-cycles,instructions,inst_retired.any --all-user -o results_${applications[$counter]}_${graphs_names[$counter2]}_cycles ./${applications[$counter]} -rounds 1 ${graphs[$counter2]}
        
        # Load-stores
        perf stat -x, -e mem_inst_retired.all_loads,mem_inst_retired.all_stores --all-user -o results_${applications[$counter]}_${graphs_names[$counter2]}_load-stores ./${applications[$counter]} -rounds 1 ${graphs[$counter2]}
        
        # Cache-misses
        perf stat -x, -e cache-misses,cache-references --all-user -o results_${applications[$counter]}_${graphs_names[$counter2]}_cache-misses ./${applications[$counter]} -rounds 1 ${graphs[$counter2]}
        
        # LLC
        perf stat -x, -e LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses --all-user -o results_${applications[$counter]}_${graphs_names[$counter2]}_LLC ./${applications[$counter]} -rounds 1 ${graphs[$counter2]}
        
        # L1
        perf stat -x, -e L1-dcache-loads,L1-dcache-stores,L1-dcache-load-misses --all-user -o results_${applications[$counter]}_${graphs_names[$counter2]}_L1 ./${applications[$counter]} -rounds 1 ${graphs[$counter2]}
        
        # Virtual Memory
        perf stat -x, -e dtlb_load_misses.miss_causes_a_walk,dtlb_store_misses.miss_causes_a_walk --all-user -o results_${applications[$counter]}_${graphs_names[$counter2]}_virtual-memory ./${applications[$counter]} -rounds 1 ${graphs[$counter2]}
        
    done
done
