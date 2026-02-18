# 1. Base latest para garantir compatibilidade com seu Banco de Dados
FROM n8nio/n8n:latest

USER root

# --- O TRANSPLANTE (Agora com as bibliotecas!) ---
# Copiamos o executável
COPY --from=alpine:latest /sbin/apk /sbin/apk

# [CORREÇÃO] Copiamos as bibliotecas que o apk precisa para rodar (libapk e cia)
COPY --from=alpine:latest /lib/libapk* /lib/

# Copiamos as configurações de repositório e o banco de dados de pacotes
COPY --from=alpine:latest /etc/apk /etc/apk
COPY --from=alpine:latest /lib/apk /lib/apk
COPY --from=alpine:latest /usr/share/apk /usr/share/apk

# Criamos a pasta de cache na marra
RUN mkdir -p /var/cache/apk

# 2. Agora instalamos o Python, Pandas e Numpy
RUN apk update && \
    apk add --no-cache python3 py3-pip py3-pandas py3-numpy

# Definimos onde o n8n vai achar o Python
ENV N8N_PYTHON_INTERPRETER=/usr/bin/python3

USER node
