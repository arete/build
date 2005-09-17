
include build/$(X_SYSTEM).make

X_SRCS = $(filter-out $(NOT_SRCS), $(notdir $(wildcard $(X_MODULE)/*.cc $(X_MODULE)/*.c)))

$(X_MODULE)_OBJS := $(addsuffix $(X_OBJEXT),$(addprefix $($(X_MODULE)_OUTPUT)/,$(basename $(notdir $(X_SRCS) $(SRCS))))) $(DEPS)

$(X_MODULE)_BINARY := $(addprefix $($(X_MODULE)_OUTPUT)/,$(BINARY))$(BINARY_EXT)

# include build/$(X_ARCH).make
# include build/$(X_CC).make

# rules

Q = @

#all:: $($(X_MODULE)_BINARY)
$(X_MODULE): $($(X_MODULE)_BINARY)

$($(X_MODULE)_OUTPUT)/%.o: $(X_MODULE)/%.c
	@echo '  LINK C    $@'
	$(Q)$(COMPILE.c) -o '$@' '$<'

$($(X_MODULE)_OUTPUT)/%.o: $(X_MODULE)/%.cc
	@echo '  LINK CXX  $@'
	$(Q)$(COMPILE.cc) -o '$@' '$<'

# only implicit rules if one binary per module ...
ifeq ($(words $(BINARY)), 1)

$($(X_MODULE)_OUTPUT)/$(BINARY).a: $($(X_MODULE)_OBJS)
	@echo '  LINK LIB $@'
	$(Q)$(AR) r '$@' $^
	$(Q)ranlib '$@'

$($(X_MODULE)_OUTPUT)/$(BINARY).so: $($(X_MODULE)_OBJS)
	@echo '  LINK DYN  $@'
	$(Q)$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -shared -o '$@' $^ $(LDFLAGS)

$($(X_MODULE)_OUTPUT)/$(BINARY)$(X_EXEEXT): $($(X_MODULE)_OBJS)
	@echo '  LINK EXEC $@'
	$(Q)$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -o '$@' $^ $(LDFLAGS)

endif
