# Dockerfile

FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential python3 python3-pip wget unzip \
    python3-dev libffi-dev
	
# Set workdir
WORKDIR /opt


RUN git clone https://github.com/micropython/micropython.git

# Build mpy-cross and rp2 ports
WORKDIR /opt/micropython

RUN make -C mpy-cross
RUN make -C ports/rp2 submodules BOARD=RPI_PICO_W
RUN make -C ports/rp2 submodules BOARD=RPI_PICO2_W


# Create volume mount point
VOLUME [ "/module" ]

# Entrypoint script
COPY assets/build.sh /opt/build.sh
RUN chmod +x /opt/build.sh

ENTRYPOINT ["/opt/build.sh"]
