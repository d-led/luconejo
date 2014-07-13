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
  OBJDIR     = Debug/obj/Debug/SimpleAmqpClient
  TARGETDIR  = ../macosx/bin/Debug
  TARGET     = $(TARGETDIR)/libSimpleAmqpClient.a
  DEFINES   += -DBOOST_NO_VARIADIC_TEMPLATES -DDEBUG -D_DEBUG -DGTEST_USE_OWN_TR1_TUPLE=1
  INCLUDES  += -I.. -I../rabbitmq-c/librabbitmq -I../SimpleAmqpClient/src -I../LuaBridge-1.0.2 -I../SimpleAmqpClient/third-party/gtest-1.7.0
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -v  -fPIC
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L..
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += 
  LDDEPS    += 
  LINKCMD    = $(AR) -rcs $(TARGET) $(OBJECTS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),release)
  OBJDIR     = Release/obj/Release/SimpleAmqpClient
  TARGETDIR  = ../macosx/bin/Release
  TARGET     = $(TARGETDIR)/libSimpleAmqpClient.a
  DEFINES   += -DBOOST_NO_VARIADIC_TEMPLATES -DRELEASE -DGTEST_USE_OWN_TR1_TUPLE=1
  INCLUDES  += -I.. -I../rabbitmq-c/librabbitmq -I../SimpleAmqpClient/src -I../LuaBridge-1.0.2 -I../SimpleAmqpClient/third-party/gtest-1.7.0
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -v  -fPIC
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L.. -Wl,-x
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += 
  LDDEPS    += 
  LINKCMD    = $(AR) -rcs $(TARGET) $(OBJECTS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

OBJECTS := \
	$(OBJDIR)/AmqpException.o \
	$(OBJDIR)/AmqpLibraryException.o \
	$(OBJDIR)/AmqpResponseLibraryException.o \
	$(OBJDIR)/BasicMessage.o \
	$(OBJDIR)/Channel.o \
	$(OBJDIR)/ChannelImpl.o \
	$(OBJDIR)/Envelope.o \
	$(OBJDIR)/MessageReturnedException.o \
	$(OBJDIR)/Table.o \
	$(OBJDIR)/TableImpl.o \

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
	@echo Linking SimpleAmqpClient
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
	@echo Cleaning SimpleAmqpClient
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

$(OBJDIR)/AmqpException.o: ../SimpleAmqpClient/src/AmqpException.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
$(OBJDIR)/AmqpLibraryException.o: ../SimpleAmqpClient/src/AmqpLibraryException.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
$(OBJDIR)/AmqpResponseLibraryException.o: ../SimpleAmqpClient/src/AmqpResponseLibraryException.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
$(OBJDIR)/BasicMessage.o: ../SimpleAmqpClient/src/BasicMessage.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
$(OBJDIR)/Channel.o: ../SimpleAmqpClient/src/Channel.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
$(OBJDIR)/ChannelImpl.o: ../SimpleAmqpClient/src/ChannelImpl.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
$(OBJDIR)/Envelope.o: ../SimpleAmqpClient/src/Envelope.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
$(OBJDIR)/MessageReturnedException.o: ../SimpleAmqpClient/src/MessageReturnedException.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
$(OBJDIR)/Table.o: ../SimpleAmqpClient/src/Table.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
$(OBJDIR)/TableImpl.o: ../SimpleAmqpClient/src/TableImpl.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"

-include $(OBJECTS:%.o=%.d)
