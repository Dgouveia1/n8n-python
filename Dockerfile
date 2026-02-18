# Imagem oficial dos runners
FROM n8nio/runners:latest

USER root

# 1. Instalação do Python e Libs (Mantido)
RUN cd /opt/runners/task-runner-python && \
    uv pip install numpy pandas

# 2. Configuração COMPLETA (Python + JavaScript)
# Adicionei o bloco "javascript" para parar o erro
RUN echo '{ \
  "task-runners": [ \
    { \
      "runner-type": "javascript", \
      "env-overrides": { \
        "NODE_FUNCTION_ALLOW_BUILTIN": "*", \
        "NODE_FUNCTION_ALLOW_EXTERNAL": "*" \
      } \
    }, \
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
