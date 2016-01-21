# GNU Make project makefile autogenerated by Premake

ifndef config
  config=debug_x32
endif

ifndef verbose
  SILENT = @
endif

.PHONY: clean prebuild prelink

ifeq ($(config),debug_x32)
  RESCOMP = windres
  TARGETDIR = ../../..
  TARGET = $(TARGETDIR)/luconejo.so
  OBJDIR = ../../../obj/linux/gmake/x32/Debug/luconejo
  DEFINES += -DBOOST_NO_VARIADIC_TEMPLATES -D_DEBUG
  INCLUDES += -I../../../rabbitmq-c/librabbitmq -I../../../SimpleAmqpClient/src -I../../../LuaBridge-1.0.2 -I../../../SimpleAmqpClient/third-party/gtest-1.7.0 -I/usr/include/lua5.1
  FORCE_INCLUDE +=
  ALL_CPPFLAGS += $(CPPFLAGS) -MMD -MP $(DEFINES) $(INCLUDES)
  ALL_CFLAGS += $(CFLAGS) $(ALL_CPPFLAGS) -m32 -g -fPIC
  ALL_CXXFLAGS += $(CXXFLAGS) $(ALL_CFLAGS)
  ALL_RESFLAGS += $(RESFLAGS) $(DEFINES) $(INCLUDES)
  LIBS += ../../../bin/linux/gmake/x32/Debug/libSimpleAmqpClient.a -lrabbitmq -llua5.1 -lboost_system -lpthread -lboost_chrono
  LDDEPS += ../../../bin/linux/gmake/x32/Debug/libSimpleAmqpClient.a
  ALL_LDFLAGS += $(LDFLAGS) -L/usr/lib32 -m32 -shared
  LINKCMD = $(CXX) -o "$@" $(OBJECTS) $(RESOURCES) $(ALL_LDFLAGS) $(LIBS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
all: $(TARGETDIR) $(OBJDIR) prebuild prelink $(TARGET)
	@:

endif

ifeq ($(config),debug_x64)
  RESCOMP = windres
  TARGETDIR = ../../..
  TARGET = $(TARGETDIR)/luconejo.so
  OBJDIR = ../../../obj/linux/gmake/x64/Debug/luconejo
  DEFINES += -DBOOST_NO_VARIADIC_TEMPLATES -D_DEBUG
  INCLUDES += -I../../../rabbitmq-c/librabbitmq -I../../../SimpleAmqpClient/src -I../../../LuaBridge-1.0.2 -I../../../SimpleAmqpClient/third-party/gtest-1.7.0 -I/usr/include/lua5.1
  FORCE_INCLUDE +=
  ALL_CPPFLAGS += $(CPPFLAGS) -MMD -MP $(DEFINES) $(INCLUDES)
  ALL_CFLAGS += $(CFLAGS) $(ALL_CPPFLAGS) -m64 -g -fPIC
  ALL_CXXFLAGS += $(CXXFLAGS) $(ALL_CFLAGS)
  ALL_RESFLAGS += $(RESFLAGS) $(DEFINES) $(INCLUDES)
  LIBS += ../../../bin/linux/gmake/x64/Debug/libSimpleAmqpClient.a -lrabbitmq -llua5.1 -lboost_system -lpthread -lboost_chrono
  LDDEPS += ../../../bin/linux/gmake/x64/Debug/libSimpleAmqpClient.a
  ALL_LDFLAGS += $(LDFLAGS) -L/usr/lib64 -m64 -shared
  LINKCMD = $(CXX) -o "$@" $(OBJECTS) $(RESOURCES) $(ALL_LDFLAGS) $(LIBS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
all: $(TARGETDIR) $(OBJDIR) prebuild prelink $(TARGET)
	@:

endif

ifeq ($(config),release_x32)
  RESCOMP = windres
  TARGETDIR = ../../..
  TARGET = $(TARGETDIR)/luconejo.so
  OBJDIR = ../../../obj/linux/gmake/x32/Release/luconejo
  DEFINES += -DBOOST_NO_VARIADIC_TEMPLATES
  INCLUDES += -I../../../rabbitmq-c/librabbitmq -I../../../SimpleAmqpClient/src -I../../../LuaBridge-1.0.2 -I../../../SimpleAmqpClient/third-party/gtest-1.7.0 -I/usr/include/lua5.1
  FORCE_INCLUDE +=
  ALL_CPPFLAGS += $(CPPFLAGS) -MMD -MP $(DEFINES) $(INCLUDES)
  ALL_CFLAGS += $(CFLAGS) $(ALL_CPPFLAGS) -m32 -O2 -fPIC
  ALL_CXXFLAGS += $(CXXFLAGS) $(ALL_CFLAGS)
  ALL_RESFLAGS += $(RESFLAGS) $(DEFINES) $(INCLUDES)
  LIBS += ../../../bin/linux/gmake/x32/Release/libSimpleAmqpClient.a -lrabbitmq -llua5.1 -lboost_system -lpthread -lboost_chrono
  LDDEPS += ../../../bin/linux/gmake/x32/Release/libSimpleAmqpClient.a
  ALL_LDFLAGS += $(LDFLAGS) -L/usr/lib32 -m32 -s -shared
  LINKCMD = $(CXX) -o "$@" $(OBJECTS) $(RESOURCES) $(ALL_LDFLAGS) $(LIBS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
all: $(TARGETDIR) $(OBJDIR) prebuild prelink $(TARGET)
	@:

endif

ifeq ($(config),release_x64)
  RESCOMP = windres
  TARGETDIR = ../../..
  TARGET = $(TARGETDIR)/luconejo.so
  OBJDIR = ../../../obj/linux/gmake/x64/Release/luconejo
  DEFINES += -DBOOST_NO_VARIADIC_TEMPLATES
  INCLUDES += -I../../../rabbitmq-c/librabbitmq -I../../../SimpleAmqpClient/src -I../../../LuaBridge-1.0.2 -I../../../SimpleAmqpClient/third-party/gtest-1.7.0 -I/usr/include/lua5.1
  FORCE_INCLUDE +=
  ALL_CPPFLAGS += $(CPPFLAGS) -MMD -MP $(DEFINES) $(INCLUDES)
  ALL_CFLAGS += $(CFLAGS) $(ALL_CPPFLAGS) -m64 -O2 -fPIC
  ALL_CXXFLAGS += $(CXXFLAGS) $(ALL_CFLAGS)
  ALL_RESFLAGS += $(RESFLAGS) $(DEFINES) $(INCLUDES)
  LIBS += ../../../bin/linux/gmake/x64/Release/libSimpleAmqpClient.a -lrabbitmq -llua5.1 -lboost_system -lpthread -lboost_chrono
  LDDEPS += ../../../bin/linux/gmake/x64/Release/libSimpleAmqpClient.a
  ALL_LDFLAGS += $(LDFLAGS) -L/usr/lib64 -m64 -s -shared
  LINKCMD = $(CXX) -o "$@" $(OBJECTS) $(RESOURCES) $(ALL_LDFLAGS) $(LIBS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
all: $(TARGETDIR) $(OBJDIR) prebuild prelink $(TARGET)
	@:

endif

OBJECTS := \
	$(OBJDIR)/luconejo.o \
	$(OBJDIR)/luconejo_lib.o \

RESOURCES := \

CUSTOMFILES := \

SHELLTYPE := msdos
ifeq (,$(ComSpec)$(COMSPEC))
  SHELLTYPE := posix
endif
ifeq (/bin,$(findstring /bin,$(SHELL)))
  SHELLTYPE := posix
endif

$(TARGET): $(GCH) ${CUSTOMFILES} $(OBJECTS) $(LDDEPS) $(RESOURCES)
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
$(OBJECTS): $(GCH) $(PCH)
$(GCH): $(PCH)
	@echo $(notdir $<)
	$(SILENT) $(CXX) -x c++-header $(ALL_CXXFLAGS) -o "$@" -MF "$(@:%.gch=%.d)" -c "$<"
endif

$(OBJDIR)/luconejo.o: ../../../src/luconejo.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(ALL_CXXFLAGS) $(FORCE_INCLUDE) -o "$@" -MF "$(@:%.o=%.d)" -c "$<"
$(OBJDIR)/luconejo_lib.o: ../../../src/luconejo_lib.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(ALL_CXXFLAGS) $(FORCE_INCLUDE) -o "$@" -MF "$(@:%.o=%.d)" -c "$<"

-include $(OBJECTS:%.o=%.d)
ifneq (,$(PCH))
  -include $(OBJDIR)/$(notdir $(PCH)).d
endif