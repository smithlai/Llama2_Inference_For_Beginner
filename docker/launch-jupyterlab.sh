#!/bin/bash
. /app/venv/bin/activate
ollama serve &
# ollama pull llama2-uncensored
#jupyter-lab --allow-root --ip 0.0.0.0  --ContentsManager.allow_hidden=True
echo "allow 10 sec for JupyterLab to start @ http://$(hostname -I | cut -d' ' -f1):$JUPYTER_PORT " && \
echo "JupterLab logging location:  /var/log/jupyter.log  (inside the container)" && \
jupyter-lab --ip 0.0.0.0 --port $JUPYTER_PORT --ContentsManager.allow_hidden=True --allow-root --notebook-dir="/app" --NotebookApp.token='' > /var/log/jupyter.log
