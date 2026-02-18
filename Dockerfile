FROM n8nio/runners:latest

USER root

# 1. Instalar Pandas e Numpy (Mantido)
RUN cd /opt/runners/task-runner-python && \
    uv pip install numpy pandas

# 2. Configuração Inteligente (Lê o padrão e aplica alterações)
# Isso evita perder o "dir" e "command" originais que causavam o erro de chdir
RUN python3 -c "import json; \
    # Carrega a config original que funciona \
    with open('/etc/task-runners.json') as f: data = json.load(f); \
    \
    # Localiza e edita o runner JavaScript \
    js = next(r for r in data['task-runners'] if r['runner-type'] == 'javascript'); \
    js['health-check-server-port'] = '5681'; \
    js.setdefault('env-overrides', {})['NODE_FUNCTION_ALLOW_BUILTIN'] = '*'; \
    js.setdefault('env-overrides', {})['NODE_FUNCTION_ALLOW_EXTERNAL'] = '*'; \
    \
    # Localiza e edita o runner Python \
    py = next(r for r in data['task-runners'] if r['runner-type'] == 'python'); \
    py['health-check-server-port'] = '5682'; \
    py.setdefault('env-overrides', {})['PYTHONPATH'] = '/opt/runners/task-runner-python'; \
    py.setdefault('env-overrides', {})['N8N_RUNNERS_STDLIB_ALLOW'] = '*'; \
    py.setdefault('env-overrides', {})['N8N_RUNNERS_EXTERNAL_ALLOW'] = 'numpy,pandas'; \
    \
    # Salva no arquivo de override que o n8n lê \
    with open('/etc/n8n-task-runners.json', 'w') as f: json.dump(data, f, indent=2);"

USER runner
