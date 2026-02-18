FROM n8nio/n8n:latest

USER root

# --- O TRANSPLANTE DO APK ---
# Copiamos apenas o que existe no Alpine moderno (v3.19+)
# Usamos a tag 'latest' para garantir compatibilidade
COPY --from=alpine:latest /sbin/apk /sbin/apk
COPY --from=alpine:latest /lib/apk /lib/apk
COPY --from=alpine:latest /etc/apk /etc/apk
COPY --from=alpine:latest /usr/share/apk /usr/share/apk

# Criamos a pasta de cache manualmente para evitar erros
RUN mkdir -p /var/cache/apk

# Agora instalamos o Python, Pandas e Numpy
RUN apk update && \
    apk add --no-cache python3 py3-pip py3-pandas py3-numpy

# Define onde o n8n vai achar o Python
ENV N8N_PYTHON_INTERPRETER=/usr/bin/python3

USER node
