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
  install:: $($(X_MODULE)_BINARY)
	$(Q)for x in $^; do \
	  case $$x in \
		*$(X_DYNEXT) ) echo INSTALL DYNLIB $$x; install $$x $(libdir) ;; \
		*$(X_LIBEXT) ) ;; \
		*$(X_EXEEXT) ) echo INSTALL EXEC   $$x; install $$x $(bindir) ;; \
	  esac ;\
	done
endif

$(X_MODULE): $($(X_MODULE)_BINARY)

$($(X_MODULE)_OUTPUT)/%.o: $(X_MODULE)/%.c
	@echo '  C         $@'
	$(Q)$(COMPILE.c) -o '$@' '$<'

$($(X_MODULE)_OUTPUT)/%.o: $($(X_MODULE)_OUTPUT)/%.cc
	@echo '  C++       $@'
	$(Q)$(COMPILE.cc) -I./ -MMD -MP -o '$@' '$<'

$($(X_MODULE)_OUTPUT)/%.o: $(X_MODULE)/%.cc
	@echo '  C++       $@'
	$(Q)$(COMPILE.cc) -MMD -MP -o '$@' '$<'

# only implicit rules if one binary per module ...
ifeq ($(words $(BINARY)), 1)

$($(X_MODULE)_OUTPUT)/$(BINARY)$(X_LIBEXT): $($(X_MODULE)_OBJS)
	@echo '  LINK LIB  $@'
	$(Q)$(LD) -r -o '$@' $^ 2> /dev/null
#	# no AR anymore due to static initilizers
#	$(Q)$(AR) r '$@' $^ 2> /dev/null
#	$(Q)$(RANLIB) '$@'

$($(X_MODULE)_OUTPUT)/$(BINARY)$(X_DYNEXT): $($(X_MODULE)_OBJS)
	@echo '  LINK DYN  $@'
	$(Q)$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -shared -o '$@' $^ $(LDFLAGS)

$($(X_MODULE)_OUTPUT)/$(BINARY)$(X_EXEEXT): $($(X_MODULE)_OBJS)
	@echo '  LINK EXEC $@'
	$(Q)$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -o '$@' $^ $(LDFLAGS)

endif

$($(X_MODULE)_OUTPUT)/%: $($(X_MODULE)_OUTPUT)/%.o $(DEPS)
	@echo '  LINK EXEC $@'
	$(Q)$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -o '$@' $^ $(LDFLAGS)
