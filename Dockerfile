FROM n8nio/runners:latest

USER root

# 1. Instalação das bibliotecas Python (numpy, pandas)
RUN cd /opt/runners/task-runner-python && \
    uv pip install numpy pandas

# 2. Criação do arquivo de configuração COMPLETO
# AQUI ESTAVA O SEGREDO: Precisamos informar o "command" e "workdir" exatos.
# Portas definidas: JS=5681, Python=5682 (Fugindo da 5680 do launcher)
RUN echo '{ \
  "task-runners": [ \
    { \
      "runner-type": "javascript", \
      "workdir": "/home/runner", \
      "command": "/usr/local/bin/node", \
      "args": ["/opt/runners/task-runner-javascript/dist/start.js"], \
      "health-check-server-port": "5681", \
      "env-overrides": { \
        "NODE_FUNCTION_ALLOW_BUILTIN": "*", \
        "NODE_FUNCTION_ALLOW_EXTERNAL": "*" \
      } \
    }, \
    { \
      "runner-type": "python", \
      "workdir": "/home/runner", \
      "command": "/opt/runners/task-runner-python/.venv/bin/python", \
      "args": ["-m", "src.main"], \
      "health-check-server-port": "5682", \
      "env-overrides": { \
        "PYTHONPATH": "/opt/runners/task-runner-python", \
        "N8N_RUNNERS_STDLIB_ALLOW": "*", \
        "N8N_RUNNERS_EXTERNAL_ALLOW": "numpy,pandas" \
      } \
    } \
  ] \
}' > /etc/n8n-task-runners.json

USER runner
