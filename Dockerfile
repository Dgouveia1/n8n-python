FROM n8nio/n8n:latest

USER root

# Script inteligente que detecta o sistema (Alpine ou Debian) e instala o Python
RUN if [ -e /sbin/apk ]; then \
        echo "--> Sistema Detectado: ALPINE"; \
        echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
        apk update && \
        apk add --no-cache python3 py3-pip py3-pandas py3-numpy; \
    elif [ -e /usr/bin/apt-get ]; then \
        echo "--> Sistema Detectado: DEBIAN"; \
        apt-get update && \
        apt-get install -y python3 python3-pip python3-pandas python3-numpy && \
        rm -rf /var/lib/apt/lists/*; \
    else \
        echo "--> ERRO: Sistema desconhecido. Imprimindo detalhes:"; \
        cat /etc/os-release; \
        exit 1; \
    fi

ENV N8N_PYTHON_INTERPRETER=/usr/bin/python3

USER node
