# SPDX-FileCopyrightText: 2026 Ami Chayun
# SPDX-License-Identifier: MIT

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    openscad xvfb xauth libgl1-mesa-dri \
    python3 python3-pil fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*

ENV LIBGL_ALWAYS_SOFTWARE=1
WORKDIR /work
ENTRYPOINT ["openscad"]
