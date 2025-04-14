# Ubuntu 22.04 and Cuda 12.4.1
FROM ghcr.io/civo-learn/civo-python-cuda12:latest

# activate micromamba env
ARG MAMBA_DOCKERFILE_ACTIVATE=1

# pypi dependacies
COPY --chown=$MAMBA_USER:$MAMBA_USER requirements.txt /tmp/requirements.txt

# install the python deps
RUN python3 -m pip install --no-cache-dir -r /tmp/requirements.txt

# mooncake installation
RUN  apt update
RUN  apt install -y unzip wget cmake git sudo
RUN  pip install pybind11
RUN  wget https://github.com/kvcache-ai/Mooncake/archive/refs/heads/main.zip
RUN  unzip main.zip
RUN  cd Mooncake-main && bash dependencies.sh && . ~/.bashrc && mkdir build && cd build \
       && cmake .. && make VERBOSE=1 && make install

# copy over the entry point
COPY --chown=$MAMBA_USER:$MAMBA_USER entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
