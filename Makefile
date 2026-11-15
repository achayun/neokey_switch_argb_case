# SPDX-FileCopyrightText: 2026 Ami Chayun
# SPDX-License-Identifier: MIT

SCAD   := neokey_argb_case.scad
IMAGE  := neokey-openscad
PARTS  := base lid
VIEWS  := preview exploded case

DOCKER := docker run --rm --init \
          --user "$(shell id -u):$(shell id -g)" -e HOME=/tmp \
          --shm-size=256m \
          -v "$(CURDIR):/work" -w /work

STL_RUN := $(DOCKER) $(IMAGE)
PNG_RUN := $(DOCKER) --entrypoint xvfb-run $(IMAGE) \
           -a -s "-screen 0 1280x1024x24" openscad
DRAW_RUN := $(DOCKER) --entrypoint python3 $(IMAGE)

STLS := $(addprefix build/stl/,$(addsuffix .stl,$(PARTS)))
PNGS := $(addprefix build/preview/,$(addsuffix .png,$(VIEWS)))

.PHONY: all image clean
all: $(STLS) $(PNGS)
image: build/.docker-image

build/.docker-image: Dockerfile
	docker build -t $(IMAGE) .
	@mkdir -p $(@D)
	@touch $@

build/stl/%.stl: $(SCAD) build/.docker-image
	@mkdir -p $(@D)
	$(STL_RUN) -D 'part="$*"' -o "$@" "$(SCAD)"

build/preview/%.png: $(SCAD) build/.docker-image
	@mkdir -p $(@D)
	$(PNG_RUN) -D 'part="$*"' -o "$@" \
		--imgsize=1200,900 --autocenter --viewall --projection=ortho "$(SCAD)"

clean:
	rm -rf build
