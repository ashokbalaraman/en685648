###################################################################################################################################################
# Author       : Ashok BALARAMAN																												  #
# Create Date  : 06-Sep-2020																													  #
# Modified Date: 06-Sep-2020																													  #
# Usage:																																		  #
# ------																																		  #
#  1. Download & Install Docker Desktop for Mac/PC(https://www.docker.com/products/docker-desktop)												  #
#  2. Save this Dockerfile in a directory and navigate to that directory in command/terminal													  #
#  3. Build the docker image (Please make sure you are in the directory where Dockerfile is copied)												  #
#     docker build . -t en685648:latest																											  #
#  4. The Docker Build process downloads the dependency directly from Dr. Stephyn's Gist														  #
#  5. Anaconda image will take < 5 minutes in 10 MBPS bandwidth																					  #
#  6. Dependent libraries should take <10 minutes in 10MBPS bandwidth																			  #
#  7. On slow networks conda/conda-forge can timeout.  Please retry. 																			  #
#  8. Here are few Docker commands that can come in handy:																						  #
#     1. Check the image       : docker image ls																								  #
#     2. Log into the container: docker build . -t en685648:latest																				  #
#     3. Start jupyterlab: docker run -i -t -p 8888:8888 en685648:latest  /bin/bash -c  "mkdir ~/en685648 && /opt/conda/bin/jupyter notebook \	  #
#        --notebook-dir=~/en685648 \																											  #
#		 --ip='*' --port=8888 \																													  #
#		 --allow-root \																															  #
#		 --NotebookApp.token = '' \																												  #
#		 --NotebookApp.password = '' --no-browser"																								  #
###################################################################################################################################################

FROM continuumio/anaconda3:latest
MAINTAINER ashokbalaraman@gmail.com
RUN apt-get update && apt-get install -y git
RUN mkdir -p /opt/en685648
WORKDIR /opt/en685648
RUN conda install ca-certificates
RUN conda config --set ssl_verify false
RUN git clone https://gist.github.com/actsasgeek/5a384af2c7fd7b4c782a3f2b4bc2fdc4
RUN conda env create -f ./5a384af2c7fd7b4c782a3f2b4bc2fdc4/environment.yml
RUN python -m ipykernel install --user --name en685648 --display-name "Python (en685648)"
WORKDIR ~
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.token = ''" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.password = ''" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.LabApp.token = ''" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.LabApp.password = ''" >> ~/.jupyter/jupyter_notebook_config.py
EXPOSE 8888
