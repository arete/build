
include build/$(X_SYSTEM).make

X_SRCS = $(filter-out $(NOT_SRCS), $(notdir $(wildcard $(X_MODULE)/*.cc $(X_MODULE)/*.c))) $(SRCS)

$(X_MODULE)_OBJS := $(addsuffix $(X_OBJEXT),$(addprefix $($(X_MODULE)_OUTPUT)/,$(basename $(X_SRCS)))) $(DEPS)

$(X_MODULE)_BINARY := $(addprefix $($(X_MODULE)_OUTPUT)/,$(BINARY))$(BINARY_EXT)



X_DEP_FILES := $(addsuffix .d,$(addprefix $($(X_MODULE)_OUTPUT)/,$(basename $(X_SRCS)))) # $(DEPS)



# include build/$(X_ARCH).make
# include build/$(X_CC).make

# dependencies

ifneq ($(X_DEP_FILES),)
  -include $(X_DEP_FILES)
endif

# rules

Q = @

ifneq ($(X_BUILD_IMPLICIT),0)
  all:: $($(X_MODULE)_BINARY)
endif

$(X_MODULE): $($(X_MODULE)_BINARY)

$($(X_MODULE)_OUTPUT)/%.o: $(X_MODULE)/%.c
	@echo '  LINK C    $@'
	$(Q)$(COMPILE.c) -o '$@' '$<'

$($(X_MODULE)_OUTPUT)/%.o: $(X_MODULE)/%.cc
	@echo '  LINK CXX  $@'
	$(Q)$(COMPILE.cc) -MMD -MP -o '$@' '$<'

# only implicit rules if one binary per module ...
ifeq ($(words $(BINARY)), 1)

$($(X_MODULE)_OUTPUT)/$(BINARY).a: $($(X_MODULE)_OBJS)
	@echo '  LINK LIB  $@'
	$(Q)$(AR) r '$@' $^ 2> /dev/null
	$(Q)ranlib '$@'

$($(X_MODULE)_OUTPUT)/$(BINARY).so: $($(X_MODULE)_OBJS)
	@echo '  LINK DYN  $@'
	$(Q)$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -shared -o '$@' $^ $(LDFLAGS)

$($(X_MODULE)_OUTPUT)/$(BINARY)$(X_EXEEXT): $($(X_MODULE)_OBJS)
	@echo '  LINK EXEC $@'
	$(Q)$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -o '$@' $^ $(LDFLAGS)

endif

$($(X_MODULE)_OUTPUT)/%: $($(X_MODULE)_OUTPUT)/%.o $(DEPS)
	@echo '  LINK EXEC $@'
	$(Q)$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -o '$@' $^ $(LDFLAGS)

