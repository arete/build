
include build/$(X_SYSTEM).make

X_SRCS = $(filter-out $(NOT_SRCS), $(notdir $(wildcard $(X_MODULE)/*.cc $(X_MODULE)/*.c)))

$(X_MODULE)_OBJS = $(addsuffix $(X_OBJEXT),$(addprefix $($(X_MODULE)_OUTPUT)/,$(basename $(notdir $(X_SRCS) $(SRCS))))) $(DEPS)

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

$($(X_MODULE)_OUTPUT)/$(BINARY).so: $($(X_MODULE)_OBJS)
	$(COMPILE.cc) -o '$@' $^

$($(X_MODULE)_OUTPUT)/$(BINARY)$(X_EXEEXT): $($(X_MODULE)_OBJS)
	$(LINK.c) $^ -o'$@'

