# A Docker image for a single-user JupyterLab environment
### Install the image
From [Docker Hub](https://hub.docker.com/r/eadade51afcc/jupyterlab-docker)

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

### Notes About Git Integration
To have Jupyterlab's Git integration work with your host-level notebook repositories, you will want to make your 
`~/.ssh` directory available by starting your Jupyterlab server this way:

```shell
$> docker run --rm -it -p 8888:8888 -v $(pwd):/notebooks -v ~/.ssh:/root/.ssh:ro -e PASSWORD="password" kernelpanek/jupyterlab:latest
```
Use the `:ro` suffix on all volume mounts you need to ensure stay read-only to Jupyterlab.

### Extending Jupyterlab's Functionality Without Rebuilding The Docker Image
The entrypoint of this Docker image will look for 3 specific files in the directory you mount to `/notebooks`. If these 
files are found, the Docker container will process them to extend the capabilities of your lab. No action is taken if 
these specifically-named files are not found.

##### `requirements.txt`
Use this file like you would for any other Python project by adding third-party module references to it. During the start 
of the container, the entrypoint will pass this file to `pip install -r ...`.

##### `aptpackages.txt`
Use this file as a line-delimited list of Aptitude packages to install to the container as it starts. The entries are 
fed to the command: `apt-get install -y ...`.

##### `labextensions.txt`
Use this file as a line-delimited list of Jupyterlab extensions to install to the container as it starts. The entries are 
fed to the command: `jupyter labextension install ...`. Check out 
[Mauhai's Awesome Jupyterlab repo](https://github.com/mauhai/awesome-jupyterlab) or the 
[NPM package repository](https://www.npmjs.com/search?q=keywords:jupyterlab-extension) for finding more extensions. 
