# Trocamos 'latest' por uma versão específica para obrigar o download novo
# e fugir do cache corrompido que está sem gerenciador de pacotes
FROM n8nio/n8n:1.77.1

USER root

# Instalamos Python 3, Pandas e Numpy usando os pacotes pré-compilados do Alpine
# (Isso é crucial: instalar via PIP no Alpine falharia ou demoraria horas compilando)
RUN apk add --update --no-cache \
    python3 \
    py3-pip \
    py3-pandas \
    py3-numpy

# Definimos a variável de ambiente (garantia extra)
ENV N8N_PYTHON_INTERPRETER=/usr/bin/python3

USER node
