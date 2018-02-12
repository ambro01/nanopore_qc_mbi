# FROM r-base:3.4.3
# Use ubuntu 14.04 base image
FROM ubuntu:14.04

# set non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

############# BEGIN INSTALLATION ##############

# Prepare to install R
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    sudo r-base gdebi-core libcurl4-gnutls-dev libcairo2-dev libxt-dev libssl-dev \
    gsl-bin net-tools less grep psmisc procps git wget libgsl0-dev \
    python-tables python-setuptools python-pip python-dev cython libhdf5-serial-dev python-rpy2

# Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda2-5.0.1-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

ENV PATH /opt/conda/bin:$PATH
RUN pip install readline
RUN pip install six==1.11.0
RUN R -e "install.packages(c('codetools', 'MASS'), repos='http://cran.rstudio.com/')"
RUN git clone https://github.com/ambro01/poretools /tmp/poretools
RUN cd /tmp/poretools && python setup.py install
RUN export PATH=$PATH:/home/poretools/.local/bin
RUN pip install --upgrade pillow

RUN R -e "install.packages(c('shiny', 'shinyjs', 'shinydashboard', 'dplyr', 'ggplot2', 'gridExtra', 'svDialogs', 'data.table', 'bit64', 'Rmisc'), repos='http://cran.rstudio.com/')"
RUN R -e "source('https://bioconductor.org/biocLite.R'); biocLite(c('IONiseR', 'rhdf5', 'minionSummaryData'))"
RUN sudo R -e "install.packages(c('png', 'imager'), repos='http://cran.rstudio.com/')"
ADD https://sourceforge.net/projects/rpore/files/0.24/poRe_0.24.tar.gz/download /tmp/poRe_0.24.tar.gz
RUN R -e "install.packages('/tmp/poRe_0.24.tar.gz', repos = NULL, type='source')"
#CMD R INSTALL /tmp/poRe_0.24.tar.gz

RUN rm -rf /srv/shiny-server/*
RUN git clone https://github.com/ambro01/NanoporeQC /srv/shiny-server
#ADD nanopore_qc/* /srv/shiny-server/
COPY shiny-server.conf /etc/shiny-srver/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh

EXPOSE 3838
CMD ["/usr/bin/shiny-server.sh"]

