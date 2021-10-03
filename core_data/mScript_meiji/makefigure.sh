#!/bin/bash
#PJM -L "rscunit=ito-a"
#PJM -L "rscgrp=ito-s"
#PJM -L "vnode=1"
#PJM -L "vnode-core=36"
#PJM -L "elapse=48:00:00"
#PJM -S

LANG=C
module load matlab/R2017a
ulimit -a

matlab -nodisplay < makefigure.m
