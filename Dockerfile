FROM nvcr.io/nvidia/cuda:12.1.1-runtime-ubuntu22.04

# 1. 基础工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends git wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 2. 安装conda
ENV CONDA_DIR=/opt/conda
RUN wget -qO /tmp/miniconda.sh \
        https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash /tmp/miniconda.sh -b -p $CONDA_DIR && rm /tmp/miniconda.sh
ENV PATH=$CONDA_DIR/bin:$PATH
RUN conda tos accept --override-channels \
       --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels \
       --channel https://repo.anaconda.com/pkgs/r

# 3. 创建craft环境
RUN conda create -y -n craft python=3.10
RUN conda run -n craft conda install -y \
        pytorch=2.2.2 torchvision=0.17.2 pytorch-cuda=12.1 \
        numpy=1.26.* opencv=4.10.* scikit-image=0.25.* scipy=1.14.* \
        -c pytorch -c nvidia -c conda-forge \
        && conda clean -afy
ENV PATH=${CONDA_DIR}/envs/craft/bin:$PATH
ENV CONDA_DEFAULT_ENV=craft

# 4. 同步craft代码(python3.10 torch2.2.2)
RUN git clone https://github.com/god-ead/CRAFT-pytorch.git
WORKDIR /workspace/CRAFT-pytorch
ENTRYPOINT ["/bin/bash", "-c", "source activate craft && exec bash"]
