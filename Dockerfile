#####################################################################################################################################################
# Author       : Ashok BALARAMAN																												    #
# Create Date  : 06-Sep-2020																													    #
# Modified Date: 13-Sep-2020																													    #
# Usage:																																		    #
# ------																																		    #
#  1. Download & Install Docker Desktop for Mac/PC(https://www.docker.com/products/docker-desktop)												    #
#  2. Save this Dockerfile in a directory and navigate to that directory in command/terminal													    #
#  3. Build the docker image (Please make sure you are in the directory where Dockerfile is copied)												    #
#     docker build . -t en685648:fall2020																										    #
#  4. The Docker Build process downloads the dependency forked from Dr. Stephyn's Gist as of 13-Sep-2020   								  		    #
#  5. Anaconda image will take < 5 minutes in 10 MBPS bandwidth																					    #
#  6. Dependent libraries should take <10 minutes in 10MBPS bandwidth																			    #
#  7. On slow networks conda/conda-forge can TIMEOUT.  Please retry. If you see an																    #
#  8. Here are few Docker commands that can come in handy:																						    #
#     1. Check the image        : docker image ls																								    #
#     2. Log into the container : docker build . -t en685648:fall2020																			    #
#     3. Start jupyterlab: docker run -i -t -p 8888:8888 en685648:latest  /bin/bash -c  "mkdir ~/en685648 && /opt/conda/bin/jupyter notebook \	    #
#        docker run -p 8888:8888 \																												    #
#                   -v "C:\Users\ashokb\Desktop\Desktop\JHU\EN.685.648.81.FA20 Data Science\Module-1":/opt/notebooks en685648:fall2020 \ 		    #
#			        /bin/bash -c "/opt/conda/bin/jupyter notebook --ip=0.0.0.0 --port=8888 --notebook-dir=/opt/notebooks --allow-root --no-browser"	#
#####################################################################################################################################################


FROM debian:latest AS anaconda3
MAINTAINER Ashok Balaraman(abalara2@jhu.edu)

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion \
	nano vim tmux

RUN wget https://repo.anaconda.com/archive/Anaconda3-2020.07-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" --ssl-no-revoke > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]


FROM anaconda3
MAINTAINER Ashok Balaraman(abalara2@jhu.edu)

RUN conda config --set ssl_verify false

RUN git clone https://gist.github.com/ashokbalaraman/dbb6a0c72fd5de48526b0102a75a99c4
RUN conda env create -f ./dbb6a0c72fd5de48526b0102a75a99c4/environment.yml
RUN python -m ipykernel install --user --name en685648 --display-name "Python (en685648)"

RUN mkdir -p /root/.jupyter
COPY jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
RUN chmod +x /root/.jupyter/jupyter_notebook_config.py

EXPOSE 8888
