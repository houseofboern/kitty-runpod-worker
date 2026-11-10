#!/bin/bash
# Link the Runpod-cached Hugging Face repo (CACHE_REPO) into ComfyUI's model folders, then start the stock worker.
set -u
C=$(ls -d /runpod-volume/huggingface-cache/hub/models--${CACHE_REPO//\//--}/snapshots/*/ 2>/dev/null | head -1)
if [ -z "$C" ]; then echo "PRESTART_FAIL: cached repo $CACHE_REPO not found"; ls -la /runpod-volume /runpod-volume/huggingface-cache/hub 2>&1 | head -20; sleep 5; exit 1; fi
M=/comfyui/models
for d in diffusion_models text_encoders vae loras; do
  mkdir -p "$M/$d"
  for f in "$C$d"/*; do [ -e "$f" ] && ln -sf "$(readlink -f "$f")" "$M/$d/$(basename "$f")"; done
done
echo "PRESTART_OK from $C"; ls -l $M/diffusion_models $M/text_encoders $M/vae $M/loras
exec /start.sh
