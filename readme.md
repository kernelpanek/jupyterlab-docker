# A Docker image for single-use JupyterLab

### Build the image
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