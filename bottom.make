
include build/$(X_SYSTEM).make

$(X_MODULE)_OBJS = $(addsuffix $(X_OBJEXT),$(addprefix $($(X_MODULE)_OUTPUT)/,$(basename $(SRCS)))) $(DEPS)

$(X_MODULE)_BINARY = $(addprefix $($(X_MODULE)_OUTPUT)/,$(BINARY))$(BINARY_EXT)

# include build/$(X_ARCH).make
# include build/$(X_CC).make

# rules

all:: $($(X_MODULE)_BINARY)
$(X_MODULE): $($(X_MODULE)_BINARY)

$($(X_MODULE)_OUTPUT)/%.o: $(X_MODULE)/%.c
	$(COMPILE.c) -o '$@' '$<'

$($(X_MODULE)_OUTPUT)/%.o: $(X_MODULE)/%.cc
	$(COMPILE.cc) -o '$@' '$<'

$($(X_MODULE)_OUTPUT)/$(BINARY).a: $($(X_MODULE)_OBJS)
	$(AR) r '$@' $^
	ranlib '$@'

$($(X_MODULE)_OUTPUT)/$(BINARY)$(X_EXEEXT): $($(X_MODULE)_OBJS)
	$(LINK.c) $^ -o'$@'

