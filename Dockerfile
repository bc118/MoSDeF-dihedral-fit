ARG PY_VERSION=3.9
FROM continuumio/miniconda3:4.10.3-alpine AS builder

EXPOSE 8888

LABEL maintainer.name="mosdef_dihedral_fit"\
  maintainer.url="https://github.com/GOMC-WSU/mosdef_dihedral_fit"

ENV PATH /opt/conda/bin:$PATH

USER root

ADD . /mosdef_dihedral_fit

WORKDIR /mosdef_dihedral_fit

# Create a group and user
RUN addgroup -S anaconda && adduser -S anaconda -G anaconda

# install basic Ubuntu packages
RUN apt-get update \
  && apt-get install -y wget pip

# Install Ubuntu libraries (libarchive13 required for mamba install)
RUN apt-get install -y libarchive13

RUN conda update conda -yq && \
  conda config --set always_yes yes --set changeps1 no && \
  . /opt/conda/etc/profile.d/conda.sh && \
  sed -i -E "s/python.*$/python="$(PY_VERSION)"/" environment.yml && \
  conda install -c conda-forge mamba && \
  mamba env create nomkl --file environment.yml && \
  conda activate mosdef_dihedral_fit && \
  mamba install -c conda-forge nomkl jupyter python="$PY_VERSION" && \
  python setup.py install && \
  echo "source activate mosdef_dihedral_fit" >> \
  /home/anaconda/.profile && \
  conda clean -afy && \
  mkdir -p /home/anaconda/data && \
  chown -R anaconda:anaconda /mosdef_dihedral_fit && \
  chown -R anaconda:anaconda /opt && \
  chown -R anaconda:anaconda /home/anaconda


WORKDIR /home/anaconda

COPY devtools/docker-entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh

USER anaconda

ENTRYPOINT ["/entrypoint.sh"]
CMD ["jupyter"]
