FROM n8nio/runners:latest

USER root

# 1. Instalação do Python e Libs
RUN cd /opt/runners/task-runner-python && \
    uv pip install numpy pandas

# 2. Configuração Ajustada
# - Portas mudadas para 5681 e 5682 (para fugir da 5680 do launcher)
# - Mantivemos as aspas "" porque o sistema exige String
RUN echo '{ \
  "task-runners": [ \
    { \
      "runner-type": "javascript", \
      "health-check-server-port": "5681", \
      "env-overrides": { \
        "NODE_FUNCTION_ALLOW_BUILTIN": "*", \
        "NODE_FUNCTION_ALLOW_EXTERNAL": "*" \
      } \
    }, \
    { \
      "runner-type": "python", \
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
