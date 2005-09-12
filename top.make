
ifndef X_ALREADYLOADED

.PHONY: all
all::

X_SYSTEM := $(shell uname -s)
X_ARCH := $(shell uname -ms | sed -e 's/ /-/g' -e 's/i.86/i386/')
X_OUTTOP ?= .
X_OUTARCH := $(X_OUTTOP)/$(X_ARCH)

endif


X_MAKEFILES := $(filter-out %$.make,$(MAKEFILE_LIST))
X_MODULE := $(patsubst %/,%,$(dir $(word $(words $(X_MAKEFILES)),$(X_MAKEFILES))))

$(X_MODULE)_OUTPUT := $(X_OUTARCH)/$(X_MODULE)

X_IGNORE := $(shell mkdir -p $($(X_MODULE)_OUTPUT))

ifndef X_ALREADYLOADED
X_ALREADYLOADED = 1
.PHONY: clean
clean::
	echo rm -rf $(X_OUTARCH)

.SUFFIXES:

endif

