#!/bin/bash
conda create -n smart_ar_smpler_x -y python=3.8 
conda activate smart_ar_smpler_x

# Install PyTorch and related packages
pip install torch==1.12.0+cu116 torchvision==0.13.0+cu116 --extra-index-url https://download.pytorch.org/whl/cu116

pip install mmcv-full==1.7.1 -f https://download.openmmlab.com/mmcv/dist/cu116/torch1.12.0/index.html

cd ../eva_avatars

pip install -r preprocess/SMPLer-X/requirements.txt
pip install -v -e preprocess/SMPLer-X/main/transformer_utils
bash scripts/bug_fix.sh

#pip dependencies
pip install av beartype fastapi uuid jaxtyping lpips
pip install onnxruntime-gpu rembg[gpu]
pip install open3d

# install colmap and pycolamp with gpu suppport if necessary
conda install -y -c conda-forge colmap pycolmap
