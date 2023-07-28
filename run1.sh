#!/bin/bash

# use bash filename.sh to execute (bad)(for windows terminal mostly like bat, DOS commands not unix)
which bash
# which <Interpreter> to check absolute path and if that Interpreter exits on ur machine
# correct method is :
# chmod +x script_name.sh
# ./script_name.sh
# cuda v117 then pytorch/torch = 1.13.1 and xformers v0.0.19
# can install torch 2.0.1/0 and xformers 0.0.20 but idk cuda version -U=--upgrade
# while (n<1): in relauncher.py, then copy config.json for settings
# pip3 uninstall <package-name>
# using pip3 !pip installer as pip3 isfor py_V3.x.x
# https://askubuntu.com/questions/590899/how-do-i-check-which-shell-i-am-using
# can't use echo without ""
echo "make sure to update requirements file then"
echo "cd /workspace/stable-diffusion-webui, pip3 install -r requirements.txt"
python --version
pip3 -V
pip3 install --upgrade pip3
# python3 -m pip install --upgrade pip
## echo "installing torch 2.0.0"
## pip3 install torch==2.0.0 torchvision torchaudio torchsde --index-url https://download.pytorch.org/whl/cu117 --upgrade(will --upgrade in behind will work)
echo "installing xformers latest requires pytorch2.0.0"
#pip3 install xformers==0.0.19
# pip3 install -U xformers
python -m xformers.info
python -m xformers.info output
pip3 list
echo "<===== DONE RUN0.SH =====>"