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
    sudo \
    r-base \
    gdebi-core \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    gsl-bin \
    net-tools \
    less \
    grep \
    psmisc \
    procps \
    git \
    wget \
    libgsl0-dev

# Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

RUN R -e "install.packages(c('shiny', 'shinyjs', 'shinydashboard', 'dplyr', 'ggplot2', 'gridExtra', 'svDialogs', 'data.table', 'bit64', 'png', 'imager'), repos='http://cran.rstudio.com/')"
RUN R -e "source('https://bioconductor.org/biocLite.R'); biocLite(c('IONiseR', 'rhdf5', 'minionSummaryData'))"

RUN rm -rf /srv/shiny-server/*
RUN git clone https://github.com/ambro01/NanoporeQC /srv/shiny-server/
#ADD nanopore_qc/* /srv/shiny-server/
COPY shiny-server.conf /etc/shiny-srver/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
COPY poRe_0.24.tar.gz /usr/bin/poRe_0.24.tar.gz

RUN R -e "install.packages('/usr/bin/poRe_0.24.tar.gz', repos = NULL, type='source')"

#CMD R INSTALL /usr/bin/poRe_0.24.tar.gz

EXPOSE 3838
CMD ["/usr/bin/shiny-server.sh"]

