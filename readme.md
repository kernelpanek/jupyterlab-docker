# A Docker image for a single-user JupyterLab environment

### Build the image
Before building the image, be sure to allocate at least 1GB of memory per CPU to your Docker for Desktop virtual machine. E.g. If you allocate 6 CPU cores, then allocate 6GB of memory.
```shell
$> docker build -t kernelpanek/jupyterlab .
```

### Run the container
In your terminal, navigate to your notebooks directory if you have one.
```shell
$> mkdir ~/my_notebooks
$> cd ~/my_notebooks
$> docker run --rm -it -p 8888:8888 -v $(pwd):/notebooks -e PASSWORD="password" kernelpanek/jupyterlab:latest 
```

Open your browser to [localhost:8888](http://localhost:8888)