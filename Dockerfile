FROM n8nio/runners:latest

USER root

# 1. Instalação do Python e Libs
RUN cd /opt/runners/task-runner-python && \
    uv pip install numpy pandas

# 2. Configuração com Portas de Health Check Definidas
# Isso resolve o erro "health-check-server-port is required"
RUN echo '{ \
  "task-runners": [ \
    { \
      "runner-type": "javascript", \
      "health-check-server-port": 5680, \
      "env-overrides": { \
        "NODE_FUNCTION_ALLOW_BUILTIN": "*", \
        "NODE_FUNCTION_ALLOW_EXTERNAL": "*" \
      } \
    }, \
    { \
      "runner-type": "python", \
      "health-check-server-port": 5681, \
      "env-overrides": { \
        "PYTHONPATH": "/opt/runners/task-runner-python", \
        "N8N_RUNNERS_STDLIB_ALLOW": "*", \
        "N8N_RUNNERS_EXTERNAL_ALLOW": "numpy,pandas" \
      } \
    } \
  ] \
}' > /etc/n8n-task-runners.json

USER runner
