# only invoke uname and compute the output top-level dir once
ifndef X_ALREADYLOADED

.PHONY: all
all::

X_SYSTEM := $(shell uname -s)
ifndef X_ARCH
  X_ARCH := $(shell uname -m)
endif

X_OUTTOP ?= .

ifndef X_OUTARCH
  X_OUTARCH := $(X_OUTTOP)/$(X_SYSTEM)-$(X_ARCH)
endif

endif

# makefiles and module name we are in
X_MAKEFILES := $(filter-out %$.make,$(MAKEFILE_LIST))
X_MODULE := $(patsubst %/,%,$(dir $(word $(words $(X_MAKEFILES)),$(X_MAKEFILES))))

# per module output dir
$(X_MODULE)_OUTPUT := $(X_OUTARCH)/$(X_MODULE)
# create that module output dir
X_IGNORE := $(shell mkdir -p $($(X_MODULE)_OUTPUT))


# the global clean target just once
ifndef X_ALREADYLOADED
X_ALREADYLOADED = 1
.PHONY: clean
clean::
	@echo "CLEANING $(X_OUTARCH)"
	$(Q)rm -rf $(X_OUTARCH)

.SUFFIXES:

endif
