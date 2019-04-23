GENDEV=/opt/m68k

AS	= $(GENDEV)/bin/m68k-elf-as
LD	= $(GENDEV)/bin/m68k-elf-ld

DEBUGGER = gens

ASFLAGS = -m68000 --register-prefix-optional 
LDFLAGS = -O1 -static -nostdlib  

OBJS 	=	neozeed.o 

ROM 	= neozeed
BIN		= $(ROM).bin

all:	$(BIN)

clean: 
	rm -f $(BIN) && rm -f $(shell find . -name '*.o') 

$(BIN): $(OBJS)
	$(LD) $(LDFLAGS) $< --oformat binary -o $@

%.o: %.s 
	@echo "AS $<"
	@$(AS) $(ASFLAGS) $< -o $@

run:
	$(DEBUGGER) $(BIN) 
