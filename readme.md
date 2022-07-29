# A Docker image for a single-user JupyterLab environment

### Build the image
Before building the image, be sure to allocate at least 1GB of memory per CPU core allocated to your Docker for Desktop virtual 
machine. E.g. If you allocate 6 CPU cores, then allocate 6GB of memory.
```shell
$> docker build -t kernelpanek/jupyterlab .
```
The build process has several long-running steps for compiling dependencies and tools. The approximate time to build with 
Docker allocated 6 cores/6GB memory is 20 minutes. It's also worth noting that the finished image will be nearly 5GB in 
size. This is because the `build-essential` package and other build tools are kept for building other Python modules that 
you add using your own `requirements.txt` file.

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