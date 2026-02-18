# Usamos a imagem ESPECIAL para runners (não a do n8n)
FROM n8nio/runners:latest

USER root

# 1. Instalamos Numpy e Pandas usando 'uv' (o gerenciador ultra-rápido do runner)
RUN cd /opt/runners/task-runner-python && \
    uv pip install numpy pandas

# 2. Criamos o arquivo de configuração JSON na marra
# (Isso libera o uso do pandas e numpy, que são bloqueados por padrão)
RUN echo '{ \
  "task-runners": [ \
    { \
      "runner-type": "python", \
      "env-overrides": { \
        "PYTHONPATH": "/opt/runners/task-runner-python", \
        "N8N_RUNNERS_STDLIB_ALLOW": "*", \
        "N8N_RUNNERS_EXTERNAL_ALLOW": "numpy,pandas" \
      } \
    } \
  ] \
}' > /etc/n8n-task-runners.json

USER runner
