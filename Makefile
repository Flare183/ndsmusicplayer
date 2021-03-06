#
# Makefile for vio2play, cheesy Linux hack version
#

CC   = gcc
CPP  = g++
CFLAGS = -c -O3

# attempt 64-bit autodetect
ifeq ($(MACHTYPE),x86_64)
CFLAGS += -DLONG_IS_64BIT=1
else
ifdef BUILD64
CFLAGS += -DLONG_IS_64BIT=1
endif
endif

CFLAGS += -DLSB_FIRST=1		# disable this for big-endian builds!

CFLAGS += -Ivio2sf -Ivio2sf/desmume -Ivio2sf/zlib -D_strnicmp=strncasecmp

CPPFLAGS = -Wno-deprecated -fno-rtti

# I might change the name of the main program soon
#EXE  = vio2play
EXE = ndsmusicplayer
LIBS = -lm -lasound

OBJS = main.o oss.o corlett.o

PREFIX := /usr/bin

# actual vio2sf / Desmume code
OBJS += vio2sf/vio2sf.o vio2sf/desmume/armcpu.o vio2sf/desmume/arm_instructions.o vio2sf/desmume/bios.o vio2sf/desmume/cp15.o 
OBJS += vio2sf/desmume/FIFO.o vio2sf/desmume/GPU.o vio2sf/desmume/matrix.o vio2sf/desmume/mc.o vio2sf/desmume/MMU.o 
OBJS += vio2sf/desmume/NDSSystem.o vio2sf/desmume/SPU.o vio2sf/desmume/thumb_instructions.o
OBJS += vio2sf/zlib/adler32.o vio2sf/zlib/crc32.o vio2sf/zlib/infback.o vio2sf/zlib/inffast.o vio2sf/zlib/inflate.o
OBJS += vio2sf/zlib/inftrees.o vio2sf/zlib/uncompr.o vio2sf/zlib/zutil.o

# build rules
%.o: %.c
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) $< -o $@

%.o: %.cpp
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) $(CPPFLAGS) $< -o $@

all: $(EXE)

# link the commandline exe
$(EXE): $(OBJS)
	@echo "Linking $@..."
	@$(CPP) -g -s -o $(EXE) $^ $(LIBS)

clean:
	@echo "Cleaning up..."
	-@rm -f $(OBJS) $(EXE)
	@rm -f vio2play
	@echo "Done."

install:
	@echo "Installing..."
	@cp -v $(EXE) $(PREFIX)
	@cd /usr/bin/
	@echo "Linking vio2player (old standard binary) to new ndsmusicplayer (new standard binary)"
	@ln -s /usr/bin/ndsmusicplayer vio2play