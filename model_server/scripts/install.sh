#!/bin/bash
conda create -n smart_ar_smpler_x -y python=3.8 
conda activate smart_ar_smpler_x

# Install PyTorch and related packages
pip install torch==1.12.0+cu116 torchvision==0.13.0+cu116 --extra-index-url https://download.pytorch.org/whl/cu116
# conda install pytorch==1.12.0 torchvision==0.13.0 torchaudio==0.12.0 pytorch-cuda=11.6 -c pytorch -c nvidia

pip install mmcv-full==1.7.1 -f https://download.openmmlab.com/mmcv/dist/cu116/torch1.12.0/index.html
pip install -r eva_avatars/preprocess/SMPLer-X/requirements.txt
pip install -v -e eva_avatars/preprocess/SMPLer-X/main/transformer_utils
bash eva_avatars/scripts/bug_fix.sh

#pip dependencies
pip install av beartype fastapi uuid jaxtyping lpips
pip install onnxruntime-gpu rembg[gpu]
pip install open3d

# install colmap and pycolamp with gpu suppport if necessary
conda install -y -c conda-forge colmap pycolmap
