FROM n8nio/runners:latest

USER root

# 1. Instalar Pandas e Numpy
RUN cd /opt/runners/task-runner-python && \
    uv pip install numpy pandas

# 2. Configuração "Flat" (Sem blocos 'with' para evitar erro de sintaxe)
# Mantém os diretórios originais e injeta apenas as portas e permissões
RUN python3 -c "import json; \
 data = json.load(open('/etc/task-runners.json')); \
 js = next(r for r in data['task-runners'] if r['runner-type'] == 'javascript'); \
 js['health-check-server-port'] = '5681'; \
 js.setdefault('env-overrides', {})['NODE_FUNCTION_ALLOW_BUILTIN'] = '*'; \
 js.setdefault('env-overrides', {})['NODE_FUNCTION_ALLOW_EXTERNAL'] = '*'; \
 py = next(r for r in data['task-runners'] if r['runner-type'] == 'python'); \
 py['health-check-server-port'] = '5682'; \
 py.setdefault('env-overrides', {})['PYTHONPATH'] = '/opt/runners/task-runner-python'; \
 py.setdefault('env-overrides', {})['N8N_RUNNERS_STDLIB_ALLOW'] = '*'; \
 py.setdefault('env-overrides', {})['N8N_RUNNERS_EXTERNAL_ALLOW'] = 'numpy,pandas'; \
 json.dump(data, open('/etc/n8n-task-runners.json', 'w'), indent=2);"

USER runner
