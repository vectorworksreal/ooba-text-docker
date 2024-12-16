FROM nvidia/cuda:11.8.0-base-ubuntu22.04

# Set noninteractive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3.10 \
    python3.10-dev \
    python3-pip \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone the repository
RUN git clone https://github.com/oobabooga/text-generation-webui.git .

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt \
    && pip3 install --no-cache-dir xformers

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV CUDA_VISIBLE_DEVICES=0
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Expose the default port
EXPOSE 7860

# Command to run the server with optimized parameters
CMD ["python3", "server.py", "--listen"]
