#!/bin/bash
# The first line of a shell script is called a "shebang" (#!). It tells the system which interpreter to use for executing the script. In this case, #!/bin/bash specifies that the script should be interpreted using the Bash shell.
# to change #!/usr/bin/python OR #!/usr/bin/zsh

echo "default shell is $SHELL"
echo "current shell is $0"
# Change directory to /workspace/stable-diffusion-webui/models
cd /workspace/stable-diffusion-webui/models

# Download the first file
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/amIReal_V4.safetensors

# Download the second file
wget https://huggingface.co/SG161222/Realistic_Vision_V5.0_noVAE/resolve/main/Realistic_Vision_V5.0.safetensors