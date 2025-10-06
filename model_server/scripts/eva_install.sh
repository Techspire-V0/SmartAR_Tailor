#!/bin/bash
conda create -n smart_ar_eva -y python=3.10
conda activate smart_ar_eva
cd ../eva_avatars
bash scripts/env_install.sh
bash scripts/bug_fix_eva.sh
cd ../
conda deactivate
