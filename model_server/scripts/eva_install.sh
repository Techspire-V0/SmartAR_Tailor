#!/bin/bash
conda create -n smart_ar_eva -y python=3.10
conda activate smart_ar_eva
bash eva_avatars/scripts/env_install.sh
bash eva_avatars/scripts/bug_fix_eva.sh
conda deactivate
