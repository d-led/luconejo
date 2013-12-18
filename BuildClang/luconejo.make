# GNU Make project makefile autogenerated by Premake
ifndef config
  config=debug
endif

ifndef verbose
  SILENT = @
endif

ifndef CC
  CC = gcc
endif

ifndef CXX
  CXX = g++
endif

ifndef AR
  AR = ar
endif

ifndef RESCOMP
  ifdef WINDRES
    RESCOMP = $(WINDRES)
  else
    RESCOMP = windres
  endif
endif

ifeq ($(config),debug)
  OBJDIR     = Debug/obj/Debug/luconejo
  TARGETDIR  = ..
  TARGET     = $(TARGETDIR)/luconejo.so
  DEFINES   += -DBOOST_NO_VARIADIC_TEMPLATES -DDEBUG -D_DEBUG -DGTEST_USE_OWN_TR1_TUPLE=1
  INCLUDES  += -I.. -I../rabbitmq-c/librabbitmq -I../SimpleAmqpClient/src -I../LuaBridge-1.0.2
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -fPIC -v  -fPIC
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L.. -L../macosx/bin/Debug -dynamiclib -flat_namespace
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../macosx/bin/Debug/libSimpleAmqpClient.a -lrabbitmq -llua -lboost_chrono-mt
  LDDEPS    += ../macosx/bin/Debug/libSimpleAmqpClient.a
  LINKCMD    = $(CXX) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),release)
  OBJDIR     = Release/obj/Release/luconejo
  TARGETDIR  = ..
  TARGET     = $(TARGETDIR)/luconejo.so
  DEFINES   += -DBOOST_NO_VARIADIC_TEMPLATES -DRELEASE -DGTEST_USE_OWN_TR1_TUPLE=1
  INCLUDES  += -I.. -I../rabbitmq-c/librabbitmq -I../SimpleAmqpClient/src -I../LuaBridge-1.0.2
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -fPIC -v  -fPIC
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L.. -L../macosx/bin/Release -Wl,-x -dynamiclib -flat_namespace
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../macosx/bin/Release/libSimpleAmqpClient.a -lrabbitmq -llua -lboost_chrono-mt
  LDDEPS    += ../macosx/bin/Release/libSimpleAmqpClient.a
  LINKCMD    = $(CXX) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

OBJECTS := \
	$(OBJDIR)/luconejo.o \
	$(OBJDIR)/luconejo_lib.o \

RESOURCES := \

SHELLTYPE := msdos
ifeq (,$(ComSpec)$(COMSPEC))
  SHELLTYPE := posix
endif
ifeq (/bin,$(findstring /bin,$(SHELL)))
  SHELLTYPE := posix
endif

.PHONY: clean prebuild prelink

all: $(TARGETDIR) $(OBJDIR) prebuild prelink $(TARGET)
	@:

$(TARGET): $(GCH) $(OBJECTS) $(LDDEPS) $(RESOURCES)
	@echo Linking luconejo
	$(SILENT) $(LINKCMD)
	$(POSTBUILDCMDS)

$(TARGETDIR):
	@echo Creating $(TARGETDIR)
ifeq (posix,$(SHELLTYPE))
	$(SILENT) mkdir -p $(TARGETDIR)
else
	$(SILENT) mkdir $(subst /,\\,$(TARGETDIR))
endif

$(OBJDIR):
	@echo Creating $(OBJDIR)
ifeq (posix,$(SHELLTYPE))
	$(SILENT) mkdir -p $(OBJDIR)
else
	$(SILENT) mkdir $(subst /,\\,$(OBJDIR))
endif

clean:
	@echo Cleaning luconejo
ifeq (posix,$(SHELLTYPE))
	$(SILENT) rm -f  $(TARGET)
	$(SILENT) rm -rf $(OBJDIR)
else
	$(SILENT) if exist $(subst /,\\,$(TARGET)) del $(subst /,\\,$(TARGET))
	$(SILENT) if exist $(subst /,\\,$(OBJDIR)) rmdir /s /q $(subst /,\\,$(OBJDIR))
endif

prebuild:
	$(PREBUILDCMDS)

prelink:
	$(PRELINKCMDS)

ifneq (,$(PCH))
$(GCH): $(PCH)
	@echo $(notdir $<)
ifeq (posix,$(SHELLTYPE))
	-$(SILENT) cp $< $(OBJDIR)
else
	$(SILENT) xcopy /D /Y /Q "$(subst /,\,$<)" "$(subst /,\,$(OBJDIR))" 1>nul
endif
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
endif

$(OBJDIR)/luconejo.o: ../src/luconejo.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
$(OBJDIR)/luconejo_lib.o: ../src/luconejo_lib.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"

-include $(OBJECTS:%.o=%.d)
