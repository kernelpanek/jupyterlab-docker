#!/bin/bash

CMD="jupyter lab --allow-root --ip=0.0.0.0 --no-browser"

if [[ -v PASSWORD ]]; then
  PASSWORD=$(python -c "from notebook.auth import passwd; print(passwd('$PASSWORD'))")
  CMD="$CMD --NotebookApp.token='' --NotebookApp.password='${PASSWORD}'"
fi

if [[ -v GIT_URL ]]; then
  git clone $GIT_URL /notebooks
fi

if [ -f /notebooks/aptpackages.txt ]; then
  echo "INFO: Found aptpackages.txt file in folder /notebooks. Installing via \"apt-get install -y\""
  apt-get update
  cat aptpackages.txt | xargs apt-get install -y
else
  echo "INFO: aptpackages.txt not found in folder /notebooks --> Continuing"
fi

if [ -f /notebooks/requirements.txt ]; then
  echo "INFO: Found requirements.txt file in folder /notebooks. Installing via \"pip install -r requirements.txt\""
  pip install -r requirements.txt
else
  echo "INFO: requirements.txt not found in folder /notebooks --> Continuing"
fi

if [ -f /notebooks/labextensions.txt ]; then
  echo "INFO: Found labextensions.txt file in folder /notebooks. Installing via \"jupyter labextension install\""
  cat labextensions.txt | xargs jupyter labextension install
else
  echo "INFO: labextensions.txt not found in folder /notebooks --> Continuing"
fi

echo
echo "Installed software:"
python --version
pip --version
jupyter --version
echo "Node $(node --version)"
echo "NPM $(npm -v)"

echo
echo "Installed Python packages:"
pip list -l

echo
echo "Installed Juypter extensions"
jupyter labextension list

echo
exec $CMD "$@"