@echo off
setlocal enabledelayedexpansion

:CHOOSE_OPTION
REM Ask user for installation type
echo [33mChoose your preferred installation:[0m
echo [32mA) Fast-Lowvram install[0m
echo [32mB) Unoptimized normal model[0m
set /p "CHOICE=Enter your choice (A or B) and press Enter: "

if /i "%CHOICE%"=="A" (
    set "INSTALL_TYPE=fast-lowvram"
) else if /i "%CHOICE%"=="B" (
    set "INSTALL_TYPE=unoptimized"
) else (
echo [31mInvalid choice. Please enter A or B.[0m
    goto CHOOSE_OPTION
)

:CHOOSE_FLUX_SCHNELL
REM Ask user if they want to download FLUX SCHNELL Model
echo [33mDo you want to download the FLUX SCHNELL Model?[0m
echo [32mA) Yes[0m
echo [32mB) No[0m
set /p "FLUX_SCHNELL_CHOICE=Enter your choice (A or B) and press Enter: "

if /i "%FLUX_SCHNELL_CHOICE%"=="A" (
    set "DOWNLOAD_FLUX_SCHNELL=yes"
) else if /i "%FLUX_SCHNELL_CHOICE%"=="B" (
    set "DOWNLOAD_FLUX_SCHNELL=no"
) else (
echo [31mInvalid choice. Please enter A or B.[0m
    goto CHOOSE_FLUX_SCHNELL
)

:CHOOSE_FLUX_GGUF
REM Ask user if they want to download FLUX GGUF Model
echo [33mDo you want to download FLUX GGUF Models?[0m
echo [32mA) Q8_0 + T5_Q8 (24GB Vram)[0m
echo [32mB) Q5_K_S + T5_Q5_K_M (16GB Vram)[0m
echo [32mC) Q4_K_S + T5_Q3_K_L (less than 12GB Vram)[0m
echo [32mD) All[0m
echo [32mE) No[0m
set /p "FLUX_GGUF_CHOICE=Enter your choice (A,B,C,D or E) and press Enter: "

if /i "%FLUX_GGUF_CHOICE%"=="A" (
    set "DOWNLOAD_GGUF=yes"
) else if /i "%FLUX_GGUF_CHOICE%"=="B" (
    set "DOWNLOAD_GGUF=yes"
) else if /i "%FLUX_GGUF_CHOICE%"=="C" (
    set "DOWNLOAD_GGUF=yes"
) else if /i "%FLUX_GGUF_CHOICE%"=="D" (
    set "DOWNLOAD_GGUF=yes"
) else if /i "%FLUX_GGUF_CHOICE%"=="E" (
    set "DOWNLOAD_GGUF=no"
) else (
echo [31mInvalid choice. Please enter A or B.[0m
    goto CHOOSE_FLUX_GGUF
)

:CHOOSE_FLUX_CONTROLNET
REM Ask user if they want to download FLUX SCHNELL Model
echo [33mDo you want to download FLUX ControlNet Models?[0m
echo [32mA) Yes[0m
echo [32mB) No[0m
set /p "FLUX_CONTROLNET_CHOICE=Enter your choice (A or B) and press Enter: "

if /i "%FLUX_CONTROLNET_CHOICE%"=="A" (
    set "DOWNLOAD_FLUX_CONTROLNET=yes"
) else if /i "%FLUX_CONTROLNET_CHOICE%"=="B" (
    set "DOWNLOAD_FLUX_CONTROLNET=no"
) else (
echo [31mInvalid choice. Please enter A or B.[0m
    goto CHOOSE_FLUX_CONTROLNET
)

:CHOOSE_FLUX_LORA
REM Ask user if they want to download FLUX LORA
echo [33mDo you want to download UmeAiRT LoRAs?[0m
echo [32mA) Yes[0m
echo [32mB) No[0m
set /p "FLUX_LORA_CHOICE=Enter your choice (A or B) and press Enter: "

if /i "%FLUX_LORA_CHOICE%"=="A" (
    set "DOWNLOAD_FLUX_LORA=yes"
) else if /i "%FLUX_LORA_CHOICE%"=="B" (
    set "DOWNLOAD_FLUX_LORA=no"
) else (
echo [31mInvalid choice. Please enter A or B.[0m
    goto CHOOSE_FLUX_LORA
)

REM Check if 7-Zip is installed and get its path
for %%I in (7z.exe) do set "SEVEN_ZIP_PATH=%%~$PATH:I"
if not defined SEVEN_ZIP_PATH (
    if exist "%ProgramFiles%\7-Zip\7z.exe" (
        set "SEVEN_ZIP_PATH=%ProgramFiles%\7-Zip\7z.exe"
    ) else if exist "%ProgramFiles(x86)%\7-Zip\7z.exe" (
        set "SEVEN_ZIP_PATH=%ProgramFiles(x86)%\7-Zip\7z.exe"
    ) else (
        echo 7-Zip is not installed. Downloading and installing...
        curl -L -o 7z-installer.exe https://www.7-zip.org/a/7z2201-x64.exe
        7z-installer.exe /S
        set "SEVEN_ZIP_PATH=%ProgramFiles%\7-Zip\7z.exe"
        if not exist "%SEVEN_ZIP_PATH%" (
            echo Installation of 7-Zip failed. Please install it manually and try again.
            exit /b 1
        )
        del 7z-installer.exe
    )
)

REM Check and install Git
git --version > NUL 2>&1
if %errorlevel% NEQ 0 (
    echo Installing Git...
    powershell -Command "& {Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.3/Git-2.41.0.3-64-bit.exe' -OutFile 'Git-2.41.0.3-64-bit.exe'; if ($LASTEXITCODE -ne 0) { exit 1 }}"
    if %errorlevel% NEQ 0 (
        echo Failed to download Git installer.
        exit /b
    )
    start /wait Git-2.41.0.3-64-bit.exe /VERYSILENT
    del Git-2.41.0.3-64-bit.exe
) else (
    echo Git already installed.
)

REM Download ComfyUI
echo [33mDownloading ComfyUI...[0m
curl -L -o ComfyUI_windows_portable_nvidia_cu121_or_cpu.7z https://github.com/comfyanonymous/ComfyUI/releases/download/latest/ComfyUI_windows_portable_nvidia_cu121_or_cpu.7z

REM Extract ComfyUI
echo [33mExtracting ComfyUI...[0m
"%SEVEN_ZIP_PATH%" x ComfyUI_windows_portable_nvidia_cu121_or_cpu.7z -o"%CD%" -y  >nul 2>&1

REM Check if extraction was successful
if not exist "ComfyUI_windows_portable" (
    echo Extraction failed. Please check the downloaded file and try again.
    exit /b 1
)

REM Delete archive
del /f ComfyUI_windows_portable_nvidia_cu121_or_cpu.7z -force


REM Navigate to custom_nodes folder
REM Update ComfyUI
cd ComfyUI_windows_portable\update
..\python_embeded\python.exe -m pip install --upgrade pip  >nul 2>&1
..\python_embeded\python.exe .\update.py ..\ComfyUI\  >nul 2>&1
if exist update_new.py (
  move /y update_new.py update.py
  echo Running updater again since it got updated.
  ..\python_embeded\python.exe .\update.py ..\ComfyUI\ --skip_self_update  >nul 2>&1
)

cd ..
cd ComfyUI\custom_nodes

REM Clone ComfyUI-Manager
echo [33mInstalling ComfyUI-Manager...[0m
git clone https://github.com/ltdrdata/ComfyUI-Manager.git >nul 2>&1
echo [33mInstalling additional nodes...[0m
echo   - Impact-Pack
git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack >nul 2>&1
cd ComfyUI-Impact-Pack
git clone https://github.com/ltdrdata/ComfyUI-Impact-Subpack impact_subpack >nul 2>&1
..\..\..\python_embeded\python.exe -s -m pip install -r requirements.txt --no-warn-script-location >nul 2>&1
..\..\..\python_embeded\python.exe -s -m pip install ultralytics --no-warn-script-location >nul 2>&1
cd ..

echo   - WAS-Suite
git clone https://github.com/WASasquatch/was-node-suite-comfyui >nul 2>&1
cd was-node-suite-comfyui
..\..\..\python_embeded\python.exe -s -m pip install -r requirements.txt --no-warn-script-location >nul 2>&1
cd ..

echo   - GGUF
git clone https://github.com/city96/ComfyUI-GGUF >nul 2>&1
cd ComfyUI-GGUF
..\..\..\python_embeded\python.exe -s -m pip install -r requirements.txt --no-warn-script-location >nul 2>&1
cd ..

echo   - Custom-Scripts
git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts >nul 2>&1

echo   - UltimateSDUpscale
git clone https://github.com/ssitu/ComfyUI_UltimateSDUpscale --recursive >nul 2>&1

echo   - rgthree
git clone https://github.com/rgthree/rgthree-comfy >nul 2>&1
cd rgthree-comfy
..\..\..\python_embeded\python.exe -s -m pip install -r requirements.txt --no-warn-script-location >nul 2>&1
cd ..

echo   - Florence2
git clone https://github.com/kijai/ComfyUI-Florence2 >nul 2>&1
cd ComfyUI-Florence2
..\..\..\python_embeded\python.exe -s -m pip install -r requirements.txt --no-warn-script-location >nul 2>&1
cd ..

echo   - KJNodes
git clone https://github.com/kijai/ComfyUI-KJNodes >nul 2>&1
cd ComfyUI-KJNodes
..\..\..\python_embeded\python.exe -s -m pip install -r requirements.txt --no-warn-script-location >nul 2>&1
cd ..

echo   - Image-Saver
git clone https://github.com/alexopus/ComfyUI-Image-Saver >nul 2>&1
cd ComfyUI-Image-Saver
..\..\..\python_embeded\python.exe -s -m pip install -r requirements.txt --no-warn-script-location >nul 2>&1
cd ..

echo   - RMBG
git clone https://github.com/1038lab/ComfyUI-RMBG >nul 2>&1
cd ComfyUI-RMBG
..\..\..\python_embeded\python.exe -s -m pip install -r requirements.txt --no-warn-script-location >nul 2>&1
cd ..

echo   - X-Flux
git clone https://github.com/XLabs-AI/x-flux-comfyui >nul 2>&1
cd x-flux-comfyui
..\..\..\python_embeded\python.exe -s -m pip install -r requirements.txt --no-warn-script-location >nul 2>&1
cd ..

echo   - mxToolkit
git clone https://github.com/Smirnov75/ComfyUI-mxToolkit >nul 2>&1

echo   - Comfyroll
git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes >nul 2>&1

echo   - PulID
git clone https://github.com/sipie800/ComfyUI-PuLID-Flux-Enhanced >nul 2>&1
cd ..\..\python_embeded
curl -L -o "insightface-0.7.3-cp311-cp311-win_amd64.whl" https://github.com/Gourieff/Assets/raw/main/Insightface/insightface-0.7.3-cp311-cp311-win_amd64.whl  >nul 2>&1
.\python.exe -m pip install --use-pep517 facexlib  >nul 2>&1
.\python.exe -m pip install git+https://github.com/rodjjo/filterpy.git  >nul 2>&1
.\python.exe -m pip install onnxruntime==1.19.2 onnxruntime-gpu==1.15.1 insightface-0.7.3-cp311-cp311-win_amd64.whl  >nul 2>&1
cd ..
cd ComfyUI\custom_nodes\ComfyUI-PuLID-Flux-Enhanced
..\..\..\python_embeded\python.exe -s -m pip install -r requirements.txt --no-warn-script-location  >nul 2>&1
cd ..\..
cd models
curl -L -o "insightface.7z" https://huggingface.co/UmeAiRT/ComfyUI-Auto_installer/resolve/main/models/insightface.7z?download=true >nul 2>&1
"%SEVEN_ZIP_PATH%" x insightface.7z -o"%CD%" -y >nul 2>&1
del /f insightface.7z -force >nul 2>&1
mkdir pulid
cd pulid
curl -L -o "pulid_flux_v0.9.0.safetensors" https://huggingface.co/UmeAiRT/ComfyUI-Auto_installer/resolve/main/models/pulid/pulid_flux_v0.9.0.safetensors?download=true >nul 2>&1
cd ..

REM Download VAE file
echo [33mDownloading VAE file...[0m
cd vae
curl -L -o ae.safetensors https://huggingface.co/UmeAiRT/ComfyUI-Auto_installer/resolve/main/models/vae/ae.safetensors?download=true

cd ..

REM Download CLIP files
echo [33mDownloading CLIP files...[0m
cd clip
curl -L -o "clip_l.safetensors" https://huggingface.co/UmeAiRT/ComfyUI-Auto_installer/resolve/main/models/clip/clip_l.safetensors?download=true
curl -L -o "longclip-L.pt" https://huggingface.co/BeichenZhang/LongCLIP-L/blob/main/longclip-L.pt?download=true
curl -L -o "t5xxl_fp8_e4m3fn.safetensors" https://huggingface.co/UmeAiRT/ComfyUI-Auto_installer/resolve/main/models/clip/t5xxl_fp8_e4m3fn.safetensors?download=true
curl -L -o "t5xxl_fp16.safetensors" https://huggingface.co/UmeAiRT/ComfyUI-Auto_installer/resolve/main/models/clip/t5xxl_fp16.safetensors?download=true
curl -L -o "ViT-L-14-TEXT-detail-improved-hiT-GmP-TE-only-HF.safetensors" https://huggingface.co/zer0int/CLIP-GmP-ViT-L-14/resolve/main/ViT-L-14-TEXT-detail-improved-hiT-GmP-TE-only-HF.safetensors?download=true

if "%DOWNLOAD_GGUF%"=="yes" (
    echo [33mDownloading FLUX GGUF encoder Model...[0m
    if /i "%FLUX_GGUF_CHOICE%"=="A" (
	curl -L -o t5-v1_1-xxl-encoder-Q8_0.gguf https://huggingface.co/city96/t5-v1_1-xxl-encoder-gguf/resolve/main/t5-v1_1-xxl-encoder-Q8_0.gguf?download=true
	) else if /i "%FLUX_GGUF_CHOICE%"=="B" (
	curl -L -o t5-v1_1-xxl-encoder-Q5_K_M.gguf https://huggingface.co/city96/t5-v1_1-xxl-encoder-gguf/resolve/main/t5-v1_1-xxl-encoder-Q5_K_M.gguf?download=true
	) else if /i "%FLUX_GGUF_CHOICE%"=="C" (
	curl -L -o t5-v1_1-xxl-encoder-Q3_K_L.gguf https://huggingface.co/city96/t5-v1_1-xxl-encoder-gguf/resolve/main/t5-v1_1-xxl-encoder-Q3_K_L.gguf?download=true
	) else if /i "%FLUX_GGUF_CHOICE%"=="D" (
	curl -L -o t5-v1_1-xxl-encoder-Q8_0.gguf https://huggingface.co/city96/t5-v1_1-xxl-encoder-gguf/resolve/main/t5-v1_1-xxl-encoder-Q8_0.gguf?download=true
	curl -L -o t5-v1_1-xxl-encoder-Q5_K_M.gguf https://huggingface.co/city96/t5-v1_1-xxl-encoder-gguf/resolve/main/t5-v1_1-xxl-encoder-Q5_K_M.gguf?download=true
	curl -L -o t5-v1_1-xxl-encoder-Q3_K_L.gguf https://huggingface.co/city96/t5-v1_1-xxl-encoder-gguf/resolve/main/t5-v1_1-xxl-encoder-Q3_K_L.gguf?download=true
	)
)
cd ..

REM Download UNET file based on user choice
echo [33mDownloading UNET file...[0m
cd unet
if "%INSTALL_TYPE%"=="fast-lowvram" (
    curl -L -o flux1-dev-fp8.safetensors https://huggingface.co/UmeAiRT/ComfyUI-Auto_installer/resolve/main/models/unet/flux1-dev-fp8.safetensors?download=true
) else (
    curl -L -o flux1-dev.sft https://huggingface.co/UmeAiRT/ComfyUI-Auto_installer/resolve/main/models/unet/flux1-dev.sft?download=true
)

if "%DOWNLOAD_GGUF%"=="yes" (
    echo [33mDownloading FLUX GGUF Model...[0m
    if /i "%FLUX_GGUF_CHOICE%"=="A" (
	curl -L -o flux1-dev-Q8_0.gguf https://huggingface.co/city96/FLUX.1-dev-gguf/resolve/main/flux1-dev-Q8_0.gguf?download=true
	) else if /i "%FLUX_GGUF_CHOICE%"=="B" (
	curl -L -o flux1-dev-Q5_K_S.gguf https://huggingface.co/city96/FLUX.1-dev-gguf/resolve/main/flux1-dev-Q5_K_S.gguf?download=true
	) else if /i "%FLUX_GGUF_CHOICE%"=="C" (
	curl -L -o flux1-dev-Q4_K_S.gguf https://huggingface.co/city96/FLUX.1-dev-gguf/resolve/main/flux1-dev-Q4_K_S.gguf?download=true
	) else if /i "%FLUX_GGUF_CHOICE%"=="D" (
	curl -L -o flux1-dev-Q8_0.gguf https://huggingface.co/city96/FLUX.1-dev-gguf/resolve/main/flux1-dev-Q8_0.gguf?download=true
	curl -L -o flux1-dev-Q5_K_S.gguf https://huggingface.co/city96/FLUX.1-dev-gguf/resolve/main/flux1-dev-Q5_K_S.gguf?download=true
	curl -L -o flux1-dev-Q4_K_S.gguf https://huggingface.co/city96/FLUX.1-dev-gguf/resolve/main/flux1-dev-Q4_K_S.gguf?download=true
	)
)

REM Download FLUX SCHNELL Model if user chose to
if "%DOWNLOAD_FLUX_SCHNELL%"=="yes" (
    echo [33mDownloading FLUX SCHNELL Model...[0m
    curl -L -o flux1-schnell-fp8.safetensors https://huggingface.co/UmeAiRT/ComfyUI-Auto_installer/resolve/main/models/unet/flux1-schnell-fp8.safetensors?download=true
)

cd ..

cd loras
REM Download FLUX SCHNELL Model if user chose to
if "%DOWNLOAD_FLUX_LORA%"=="yes" (
    echo [33mDownloading UmeAiRT LoRAs...[0m
    curl -L -o ume_sky_v2.safetensors https://huggingface.co/UmeAiRT/FLUX.1-dev-LoRA-Ume_Sky/resolve/main/ume_sky_v2.safetensors?download=true
    curl -L -o ume_modern_pixelart.safetensors https://huggingface.co/UmeAiRT/FLUX.1-dev-LoRA-Modern_Pixel_art/resolve/main/ume_modern_pixelart.safetensors?download=true
    curl -L -o ume_classic_Romanticism.safetensors https://huggingface.co/UmeAiRT/FLUX.1-dev-LoRA-Romanticism/resolve/main/ume_classic_Romanticism.safetensors?download=true
    curl -L -o ume_classic_impressionist.safetensors https://huggingface.co/UmeAiRT/FLUX.1-dev-LoRA-Impressionism/resolve/main/ume_classic_impressionist.safetensors?download=true
    curl -L -o ume_the-little-newspaper.safetensors https://huggingface.co/UmeAiRT/FLUX.1-dev-LoRA-Ume_J1900/resolve/main/umej1900.safetensors?download=true
    curl -L -o ume_knight.safetensors https://huggingface.co/UmeAiRT/FLUX.1-dev-LoRA-Ume_Knight/resolve/main/ume_gachaak.safetensors?download=true
)

cd ..

REM Download upscale model
echo [33mDownloading upscale models...[0m
cd upscale_models
curl -L -o 4x_NMKD-Siax_200k.pth https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/4x_NMKD-Siax_200k.pth?download=true
curl -L -o 4x-ClearRealityV1.pth https://huggingface.co/skbhadra/ClearRealityV1/resolve/main/4x-ClearRealityV1.pth?download=true

cd ..

mkdir LLM
mkdir .\xlabs\controlnets
cd xlabs\controlnets
REM Download FLUX ControlNet Models if user chose to
if "%DOWNLOAD_FLUX_CONTROLNET%"=="yes" (
    echo [33mDownloading FLUX ControlNet Models...[0m
    curl -L -o flux-canny-controlnet-v3.safetensors https://huggingface.co/XLabs-AI/flux-controlnet-canny-v3/resolve/main/flux-canny-controlnet-v3.safetensors?download=true
    curl -L -o flux-depth-controlnet-v3.safetensors https://huggingface.co/XLabs-AI/flux-controlnet-depth-v3/resolve/main/flux-depth-controlnet-v3.safetensors?download=true
    curl -L -o flux-hed-controlnet-v3.safetensors https://huggingface.co/XLabs-AI/flux-controlnet-hed-v3/resolve/main/flux-hed-controlnet-v3.safetensors?download=true
	cd ..\..
	cd unet
	curl -L -o flux1-depth-dev-fp8.safetensors https://huggingface.co/boricuapab/flux1-depth-dev-fp8/resolve/main/flux1-depth-dev-fp8.safetensors?download=true
	curl -L -o flux1-canny-dev-fp8.safetensors https://huggingface.co/boricuapab/flux1-canny-dev-fp8/resolve/main/flux1-canny-dev-fp8.safetensors?download=true
	if "%DOWNLOAD_GGUF%"=="yes" (
		echo [33mDownloading ControlNet GGUF Model...[0m
		if /i "%FLUX_GGUF_CHOICE%"=="A" (
		curl -L -o flux1-depth-dev-fp16-Q8_0-GGUF.gguf https://huggingface.co/SporkySporkness/FLUX.1-Depth-dev-GGUF/resolve/main/flux1-depth-dev-fp16-Q8_0-GGUF.gguf?download=true
		curl -L -o flux1-canny-dev-fp16-Q8_0-GGUF.gguf https://huggingface.co/SporkySporkness/FLUX.1-Canny-dev-GGUF/resolve/main/flux1-canny-dev-fp16-Q8_0-GGUF.gguf?download=true
		) else if /i "%FLUX_GGUF_CHOICE%"=="B" (
		curl -L -o flux1-depth-dev-fp16-Q5_0-GGUF.gguf https://huggingface.co/SporkySporkness/FLUX.1-Depth-dev-GGUF/resolve/main/flux1-depth-dev-fp16-Q5_0-GGUF.gguf?download=true
		curl -L -o flux1-canny-dev-fp16-Q5_0-GGUF.gguf https://huggingface.co/SporkySporkness/FLUX.1-Canny-dev-GGUF/resolve/main/flux1-canny-dev-fp16-Q5_0-GGUF.gguf?download=true
		) else if /i "%FLUX_GGUF_CHOICE%"=="C" (
		curl -L -o flux1-depth-dev-fp16-Q4_0-GGUF.gguf https://huggingface.co/SporkySporkness/FLUX.1-Depth-dev-GGUF/resolve/main/flux1-depth-dev-fp16-Q4_0-GGUF.gguf?download=true
		curl -L -o flux1-canny-dev-fp16-Q4_0-GGUF.gguf https://huggingface.co/SporkySporkness/FLUX.1-Canny-dev-GGUF/resolve/main/flux1-canny-dev-fp16-Q4_0-GGUF.gguf?download=true
		) else if /i "%FLUX_GGUF_CHOICE%"=="D" (
		curl -L -o flux1-depth-dev-fp16-Q8_0-GGUF.gguf https://huggingface.co/SporkySporkness/FLUX.1-Depth-dev-GGUF/resolve/main/flux1-depth-dev-fp16-Q8_0-GGUF.gguf?download=true
		curl -L -o flux1-depth-dev-fp16-Q5_0-GGUF.gguf https://huggingface.co/SporkySporkness/FLUX.1-Depth-dev-GGUF/resolve/main/flux1-depth-dev-fp16-Q5_0-GGUF.gguf?download=true
		curl -L -o flux1-depth-dev-fp16-Q4_0-GGUF.gguf https://huggingface.co/SporkySporkness/FLUX.1-Depth-dev-GGUF/resolve/main/flux1-depth-dev-fp16-Q4_0-GGUF.gguf?download=true
		curl -L -o flux1-canny-dev-fp16-Q8_0-GGUF.gguf https://huggingface.co/SporkySporkness/FLUX.1-Canny-dev-GGUF/resolve/main/flux1-canny-dev-fp16-Q8_0-GGUF.gguf?download=true
		curl -L -o flux1-canny-dev-fp16-Q5_0-GGUF.gguf https://huggingface.co/SporkySporkness/FLUX.1-Canny-dev-GGUF/resolve/main/flux1-canny-dev-fp16-Q5_0-GGUF.gguf?download=true
		curl -L -o flux1-canny-dev-fp16-Q4_0-GGUF.gguf https://huggingface.co/SporkySporkness/FLUX.1-Canny-dev-GGUF/resolve/main/flux1-canny-dev-fp16-Q4_0-GGUF.gguf?download=true
		)
	)
	cd ..
	cd controlnet
	curl -L -o diffusion_pytorch_model_promax.safetensors https://huggingface.co/UmeAiRT/ComfyUI-Auto_installer/resolve/main/models/controlnet/diffusion_pytorch_model_promax.safetensors?download=true
	curl -L -o Shakker-LabsFLUX1-dev-ControlNet-Union-Pro.safetensors https://huggingface.co/UmeAiRT/ComfyUI-Auto_installer/resolve/main/models/controlnet/Shakker-LabsFLUX1-dev-ControlNet-Union-Pro.safetensors?download=true
	cd ..
)

cd ..
mkdir .\user\default
echo [33mDownloading comfy settings...[0m
cd user\default
curl -L -o comfy.settings.json https://huggingface.co/UmeAiRT/ComfyUI-Auto_installer/resolve/main/others/comfy.settings.json?download=true
echo [33mDownloading comfy workflow...[0m
mkdir .\workflows
cd workflows
curl -L -o "UmeAiRT-Flux_Workflow.7z" https://huggingface.co/UmeAiRT/ComfyUI-Auto_installer/resolve/main/workflows/UmeAiRT-Flux_Workflow.7z?download=true
"%SEVEN_ZIP_PATH%" x "UmeAiRT-Flux_Workflow.7z" -o"%CD%" -y   >nul 2>&1
del /f "UmeAiRT-Flux_Workflow.7z" -force   >nul 2>&1
cd ..\..\..\..

REM Final steps based on user choice
if "%INSTALL_TYPE%"=="fast-lowvram" (
    echo Downloading special run file for fast-lowvram...
    curl -L -o "run_nvidia_gpu-LOWVRAM.bat" "https://huggingface.co/UmeAiRT/ComfyUI-Auto_installer/resolve/main/scripts/run_nvidia_gpu-LOWVRAM.bat?download=true"
    echo ComfyUI and FLUX installed. Running ComfyUI...
    call "run_nvidia_gpu-LOWVRAM.bat"
) else (
    echo ComfyUI and FLUX installed. HAVE FUN ;)
)