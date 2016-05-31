ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TCF_AGENT_DIR := $(abspath ../../agent)
include $(TCF_AGENT_DIR)/Makefile.inc

TCF_PROPRIETARY_ROOT_DIR = $(abspath $(ROOT_DIR)/../../wr_extensions/agent)
NOPOLL_VER=0.2.7.b164
NOPOLL_DIR=$(abspath $(TCF_PROPRIETARY_ROOT_DIR)/../nopoll-0.2.7.b164)
NOPOLL_OUTDIR=$(BINDIR)/nopoll-$(NOPOLL_VER)/
NOPOLL_LIB=$(NOPOLL_OUTDIR)/src/.libs/libnopoll.a

EXTRA_INCDIRS := $(ROOT_DIR) $(ROOT_DIR)system/$(OPSYS) $(ROOT_DIR)/machine/$(MACHINE) $(TCF_PROPRIETARY_ROOT_DIR) $(TCF_PROPRIETARY_ROOT_DIR)/system/$(OPSYS) $(TCF_PROPRIETARY_ROOT_DIR)/machine/$(MACHINE) $(TCF_PROPRIETARY_ROOT_DIR)
override CFLAGS += $(foreach dir,$(EXTRA_INCDIRS),-I$(dir)) $(OPTS)

vpath %.c $(TCF_PROPRIETARY_ROOT_DIR)

HFILES := $(foreach dir,$(SRCDIRS),$(wildcard $(dir)/*.h)) $(HFILES) $(wildcard $(NOPOLL_DIR)/src/nopoll.h) $(wildcard $(TCF_PROPRIETARY_ROOT_DIR)/tcf/services/*.h) $(wildcard $(TCF_PROPRIETARY_ROOT_DIR)/tcf/framework/*.h)
CFILES := $(sort $(foreach dir,$(SRCDIRS),$(wildcard $(dir)/*.c)) $(CFILES))
CFILES := $(sort $(wildcard tcf/main/*.c) $(CFILES))
CFILES := $(sort $(foreach fnm,$(wildcard $(TCF_PROPRIETARY_ROOT_DIR)/tcf/services/*.c),$(subst ^$(TCF_PROPRIETARY_ROOT_DIR)/,,^$(fnm)))  $(CFILES))
CFILES := $(sort $(foreach fnm,$(wildcard $(TCF_PROPRIETARY_ROOT_DIR)/tcf/framework/*.c),$(subst ^$(TCF_PROPRIETARY_ROOT_DIR)/,,^$(fnm)))  $(CFILES))

EXEC = $(BINDIR)/device$(EXTEXE)

all:    $(EXEC)

make_test:
	@echo CFLAGS: $(CFLAGS)
	@echo HFILES: $(HFILES)
	@echo CFILES: $(CFILES)

$(NOPOLL_OUTDIR)/config.h: $(NOPOLL_TAR) Makefile
	@$(RMDIR) $(NOPOLL_OUTDIR)
	@$(MKDIR) $(NOPOLL_OUTDIR)
	@cp -f $(NOPOLL_DIR)/VERSION $(NOPOLL_OUTDIR)
	cd $(NOPOLL_OUTDIR) && $(NOPOLL_DIR)/configure $(CONFIGURE_FLAGS) --src=$(NOPOLL_DIR)

.PHONY: $(NOPOLL_LIB)

$(NOPOLL_LIB): $(NOPOLL_OUTDIR)/config.h Makefile
ifeq ($(CONF),Debug)
	cd $(NOPOLL_OUTDIR) && make CFLAGS="-g"
else
	cd $(NOPOLL_OUTDIR) && make
endif

$(BINDIR)/libtcf$(EXTLIB) : $(OFILES)
	$(AR) $(AR_FLAGS) $@ $^

$(EXEC): $(NOPOLL_LIB) $(BINDIR)/tcf/main/main$(EXTOBJ) $(BINDIR)/libtcf$(EXTLIB)
	$(CC) $(CFLAGS) -o $@ $(BINDIR)/tcf/main/main$(EXTOBJ) $(BINDIR)/libtcf$(EXTLIB) $(LIBS) $(NOPOLL_LIB)

$(BINDIR)/%$(EXTOBJ): %.c $(HFILES) Makefile $(NOPOLL_LIB)
	@$(call MKDIR,$(dir $@))
	$(CC) $(CFLAGS) -I$(NOPOLL_OUTDIR)/src -I$(NOPOLL_DIR)/src -c -o $@ $<

$(BINDIR)/%$(EXTOBJ): $(TCF_AGENT_DIR)/%.c $(HFILES) Makefile
	@$(call MKDIR,$(dir $@))
	$(CC) $(CFLAGS) -c -o $@ $<

install: $(EXEC)
	cp $(EXEC) $(INSTALLDIR)/

clean:
	$(call RMDIR,$(BINDIR))
