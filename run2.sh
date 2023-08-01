#!/bin/bash

echo "while (n<1): in relauncher.py, then copy config.json for settings"
cd /workspace/stable-diffusion-webui/models
echo "installing Models(ckpt, safetensor, diffusers, pickle, etc)"
#wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned.ckpt
# wget <url of you model to download>  <-- uncomment this and copy paste to add more links
# make sure that file endings are set correctly for differnt OS types like Dos based unix based etc.
cd /workspace/stable-diffusion-webui/models/Lora
echo "installing LORAS"
# wget <url of you model to download>  <-- uncomment this and copy paste to add more links
echo "installing Upscalers"
# wget <url of you model to download>  <-- uncomment this and copy paste to add more links
cd /workspace/stable-diffusion-webui/models/VAE
echo "installing VAE(s) ( variational autoencoder )"
# wget <url of you model to download>  <-- uncomment this and copy paste to add more links
echo "installing embeddings(Textural Inversions)"
# wget <url of you model to download>  <-- uncomment this and copy paste to add more links
cd /workspace/stable-diffusion-webui/extensions
echo "Installing extensions(aspect ratio, civitai helper, photopea embed, dynamic prompt, ultimate upscaler, system info, control net = no, dreambooth = no, lyCORIS = yes)"
#cd /workspace/stable-diffusion-webui/extensions/sd-webui-controlnet/models
#echo installing Contronet Models(pth files from huggingface https://huggingface.co/lllyasviel/ControlNet-v1-1/tree/main)
# wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth
# wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.yaml
# wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.pth
#wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.yaml
#wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg.pth
# wget <url of you model to download>  <-- uncomment this and copy paste to add more links
echo "<===== DONE RUN.SH =====>"