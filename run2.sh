#!/bin/bash

echo "while (n<1): in relauncher.py, then copy config.json for settings"
cd /workspace/stable-diffusion-webui/models
echo "installing Models(ckpt, safetensor, diffusers, pickle, etc)"
#wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned.ckpt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/amIReal_V4.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/cameraRealism.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/epicrealism_pureEvolutionV3.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/photon_v1.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/realEpicMajic_v10.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/wafflemix_v4Wafflemania.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/revAnimated_v122.safetensors
wget https://huggingface.co/SG161222/Realistic_Vision_V5.0_noVAE/resolve/main/Realistic_Vision_V5.0.safetensors
cd /workspace/stable-diffusion-webui/models/Lora
echo "installing LORAS"
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/theovercomer8sContrastFix_sd15.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/hairdetailer.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/LowRA.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/FilmVelvia3.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/1shoulder_dress.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/After_Shower1.1.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/BLAshadow_AIARTBOT_v1.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/Bandeau-fC-V1.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/GodPussy1%20v4%20Inpainting.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/GodPussy1%20v4.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/InniePussy1%20v4.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/InstantPhotoX3.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/InstantPhotoX3.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/NegStd3.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/Tanlines05.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/UI-UX-05.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/XPrealistic.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/add_detail.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/back_view.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/background_detail_enhanced_simplified.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/bottom_view.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/chill_mayuki.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/detailed_eye-10.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/edgBardot.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/emotions_lora.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/flashlightphoto_v1.5a.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/floral_prom_dress.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/foodphoto.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/isf.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/jumper_dress-07.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/lora_perfecteyes_v1_from_v1_160.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/luxury_dress.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/more_details.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/off_shoulder_bandage_dress.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/old%20money.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/oversized_coat-10.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/oversized_puffer_jacket-10.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/oversized_shirt.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/oversized_sweater.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/perfecteyes-000007.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/pokies_9.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/polyhedron_skinny_all.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/psf1.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/puff_dress-10.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/side_view_perspective-10.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/simple_background_v2.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/striped_dress-10.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/testre3(0.7).safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/loras/top_view_perspective-10.safetensors
cd /workspace/stable-diffusion-webui/models/ESRGAN
echo "installing Upscalers"
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/upscalers/4x-UltraSharp.pth
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/upscalers/4x_NMKD-Siax_200k.pth
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/upscalers/x1_ITF_SkinDiffDetail_Lite_v1.pth
cd /workspace/stable-diffusion-webui/models/VAE
echo "installing VAE(s) ( variational autoencoder )"
wget https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.ckpt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/difconsistencyRAWVAE_v10.pt
cd /workspace/stable-diffusion-webui/embeddings
echo "installing embeddings(Textural Inversions)"
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/Asian-Less-Neg.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/BadDream.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/BadNegAnatomyV1-neg.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/FastNegativeV2.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/LikenessHelpbyShurik3.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/UnrealisticDream.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/aid210.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/bad_pictures.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/charturnerv2.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/civit_nsfw.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/defiance512.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/easynegative.safetensors
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/epiCNegative.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/epiCRealism.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/fcPortrait.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/futurabreeze5000v5.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/futuralacylotus4825v5.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/happy512.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/negative_hand-neg.pt
wget https://huggingface.co/diffusedguy/model_collection/resolve/main/TI_embeddings/realisticvision-negative-embedding.pt
cd /workspace/stable-diffusion-webui/extensions
echo "Installing extensions(aspect ratio, civitai helper, photopea embed, dynamic prompt, ultimate upscaler, system info, control net = no, dreambooth = no, lyCORIS = yes)"
#cd /workspace/stable-diffusion-webui/extensions/sd-webui-controlnet/models
#echo installing Contronet Models(pth files from huggingface https://huggingface.co/lllyasviel/ControlNet-v1-1/tree/main)
# wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth
# wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.yaml
# wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.pth
#wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.yaml
#wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg.pth
git clone https://github.com/vladmandic/sd-extension-system-info
git clone https://github.com/adieyal/sd-dynamic-prompts
git clone https://github.com/butaixianran/Stable-Diffusion-Webui-Civitai-Helper
git clone https://github.com/thomasasfk/sd-webui-aspect-ratio-helper
git clone https://github.com/KohakuBlueleaf/a1111-sd-webui-lycoris
git clone https://github.com/Coyote-A/ultimate-upscale-for-automatic1111
git clone https://github.com/yankooliveira/sd-webui-photopea-embed
#git clone https://github.com/d8ahazard/sd_dreambooth_extension
#git clone https://github.com/lllyasviel/ControlNet
echo "<===== DONE RUN.SH =====>"