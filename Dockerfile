# 1. Mantemos a latest para não quebrar seu banco de dados
FROM n8nio/n8n:latest

USER root

# --- A MÁGICA ACONTECE AQUI ---
# Como a imagem é "Hardened" e não tem 'apk', nós copiamos ele
# de uma imagem Alpine oficial (versão edge para bater com a 3.22 do n8n)
COPY --from=alpine:edge /sbin/apk /sbin/apk
COPY --from=alpine:edge /lib/apk /lib/apk
COPY --from=alpine:edge /etc/apk /etc/apk
COPY --from=alpine:edge /usr/share/apk /usr/share/apk
COPY --from=alpine:edge /var/lib/apk /var/lib/apk

# 2. Agora que "transplantamos" o apk, podemos instalar o Python normalmente
RUN apk update && \
    apk add --no-cache python3 py3-pip py3-pandas py3-numpy

# Configuração padrão
ENV N8N_PYTHON_INTERPRETER=/usr/bin/python3

USER node
