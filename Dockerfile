FROM nvcr.io/nvidia/cuda:12.1.1-runtime-ubuntu22.0

# 1. 基础工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends git wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 2. 创建 craft 环境
ENV CONDA_DIR=/opt/conda
RUN conda create -y -n craft python=3.10
RUN conda run -n craft conda install -y \
        pytorch=2.2.2 torchvision=0.17.2 pytorch-cuda=12.1 \
        numpy=1.26.* opencv=4.10.* scikit-image=0.25.* scipy=1.14.* \
        -c pytorch -c nvidia -c conda-forge \
        && conda clean -afy
ENV PATH=${CONDA_DIR}/envs/craft/bin:$PATH
ENV CONDA_DEFAULT_ENV=craft

# 3. 同步代码
RUN git clone https://github.com/god-ead/CRAFT-pytorch.git
WORKDIR /workspace/CRAFT-pytorch
ENTRYPOINT ["/bin/bash", "-c", "source activate craft && exec bash"]
