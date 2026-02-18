# Baseado na imagem oficial
FROM n8nio/n8n:latest

# Viramos root para instalar pacotes
USER root

# Instala Python 3, Pandas e Numpy direto dos repositórios do Alpine Linux
# Isso é MUITO mais rápido que compilar via PIP
RUN apk add --update --no-cache python3 py3-pip py3-pandas py3-numpy

# (Opcional) Instala outras libs leves via pip se precisar
# RUN pip3 install requests --break-system-packages

# Volta para o usuário padrão do n8n por segurança
USER node
