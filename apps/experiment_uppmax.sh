#!/bin/bash

applications=("BFS" "PageRankDelta" "Radii" "KCore" "BellmanFord")
graphs=("/proj/uppstore2017059/common/graph_datasets/com-orkut.ungraph_ligra" "/proj/uppstore2017059/common/graph_datasets/email-Eu-core_ligra" "/proj/uppstore2017059/common/graph_datasets/soc-LiveJournal1_ligra" "/proj/uppstore2017059/common/graph_datasets/twitter-2010_ligra")
graphs_names=("com-orkut" "email-Eu-core" "soc_liveJournal1" "twitter-2010")

for (( counter=0; counter<${#applications[@]}; counter++ ));
do
    for (( counter2=0; counter2<${#graphs[@]}; counter2++ ));
    do
        # Branch misses
        perf stat -x, -e branch-instructions:u,branch-misses:u -o results_${applications[$counter]}_${graphs_names[$counter2]}_branchs ./${applications[$counter]} -rounds 1 ${graphs[$counter2]}
        
        # Cycles
        perf stat -x, -e cycles:u,ref-cycles:u,instructions:u,inst_retired.any:u -o results_${applications[$counter]}_${graphs_names[$counter2]}_cycles ./${applications[$counter]} -rounds 1 ${graphs[$counter2]}
        
        # Load-stores
        perf stat -x, -e mem_inst_retired.all_loads:u,mem_inst_retired.all_stores:u -o results_${applications[$counter]}_${graphs_names[$counter2]}_load-stores ./${applications[$counter]} -rounds 1 ${graphs[$counter2]}
        
        # Cache-misses
        perf stat -x, -e cache-misses:u,cache-references:u -o results_${applications[$counter]}_${graphs_names[$counter2]}_cache-misses ./${applications[$counter]} -rounds 1 ${graphs[$counter2]}
        
        # LLC
        perf stat -x, -e LLC-loads:u,LLC-load-misses:u,LLC-stores:u,LLC-store-misses:u -o results_${applications[$counter]}_${graphs_names[$counter2]}_LLC ./${applications[$counter]} -rounds 1 ${graphs[$counter2]}
        
        # L1
        perf stat -x, -e L1-dcache-loads:u,L1-dcache-stores:u,L1-dcache-load-misses:u -o results_${applications[$counter]}_${graphs_names[$counter2]}_L1 ./${applications[$counter]} -rounds 1 ${graphs[$counter2]}
        
        # Virtual Memory
        perf stat -x, -e dtlb_load_misses.miss_causes_a_walk:u,dtlb_store_misses.miss_causes_a_walk:u -o results_${applications[$counter]}_${graphs_names[$counter2]}_virtual-memory ./${applications[$counter]} -rounds 1 ${graphs[$counter2]}
        
    done
done
