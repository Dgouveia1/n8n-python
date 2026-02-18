FROM n8nio/n8n:latest

USER root

# Em Debian, usamos apt-get em vez de apk
# Instalamos o Python e as bibliotecas direto do sistema (mais rápido e estável)
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-pandas python3-numpy && \
    rm -rf /var/lib/apt/lists/*

USER node
