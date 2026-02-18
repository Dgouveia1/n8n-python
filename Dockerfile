FROM n8nio/n8n:latest

USER root

# 1. Usamos o caminho COMPLETO do apk (/sbin/apk) para evitar erro de "not found"
# 2. Adicionamos o repositório "community" onde vivem o pandas e numpy do Alpine
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    /sbin/apk update && \
    /sbin/apk add --no-cache \
    python3 \
    py3-pip \
    py3-pandas \
    py3-numpy

# Definimos a variável aqui também para garantir
ENV N8N_PYTHON_INTERPRETER=/usr/bin/python3

USER node
