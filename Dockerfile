# Voltamos para a latest para recuperar a compatibilidade com seu banco de dados
FROM n8nio/n8n:latest

USER root

# Tentamos instalar via APK (Alpine).
# Usamos o caminho completo /sbin/apk para garantir que ele ache o comando.
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache python3 py3-pip py3-pandas py3-numpy

ENV N8N_PYTHON_INTERPRETER=/usr/bin/python3

USER node
