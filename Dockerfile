ARG BASE=kitty-base:local
FROM ${BASE}
COPY prestart.sh /prestart.sh
RUN chmod +x /prestart.sh && cd /comfyui && python -c "import comfy, torch; print('torch', torch.__version__)" && grep -rl "krea2" /comfyui/comfy | head -3
CMD ["/prestart.sh"]
