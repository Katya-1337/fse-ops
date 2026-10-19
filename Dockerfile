# Builder: compile the CPU CppExtension wheel (work fat).
FROM ubuntu:24.04 AS build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 \
        python3-dev \
        python3-pip \
        build-essential \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN python3 -m pip install --break-system-packages torch --index-url https://download.pytorch.org/whl/cpu
COPY . .
RUN python3 -m pip wheel . --no-deps -w /wheels

# Final: CPU torch + wheel only; run pytest from the installed package (ship thin).
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --break-system-packages torch --index-url https://download.pytorch.org/whl/cpu
COPY --from=build /wheels /wheels
RUN python3 -m pip install --break-system-packages /wheels/*.whl
RUN python3 -m pip install --break-system-packages pytest
COPY tests /opt/tests
CMD ["python3", "-m", "pytest", "-q", "/opt/tests"]
