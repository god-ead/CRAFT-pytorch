FROM post_analy:latest

# 1. 基础工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends git wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 2. 创建 craft 环境
ENV CONDA_DIR=/opt/conda
# CPU - 基础镜像沿用 continuumio/miniconda3
RUN conda create -y -n craft python=3.10
RUN conda run -n craft conda install -y -c pytorch \
        pytorch=2.2.2 torchvision=0.17.2
RUN conda run -n craft conda install \
        numpy=1.26.* \
        opencv=4.10.* scikit-image=0.25.* scipy=1.14.*
RUN conda clean -afy

ENV PATH=${CONDA_DIR}/envs/craft/bin:$PATH
ENV CONDA_DEFAULT_ENV=craft

# 3. 克隆项目代码
WORKDIR /workspace
RUN git clone https://github.com/clovaai/CRAFT-pytorch.git

# 4. 下载通用预训练权重
#RUN mkdir -p /workspace/craft/weights && \
#    conda run -n craft gdown -O /workspace/craft/weights/craft_mlt_25k.pth \
#         1Jk4eGD7crsqCCg9C9VjCLkMN3ze8kutZ

WORKDIR /workspace/CRAFT-pytorch
ENTRYPOINT ["/bin/bash", "-c", "source activate craft && exec bash"]
