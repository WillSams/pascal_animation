GENDEV=/opt/m68k

AS	= $(GENDEV)/bin/m68k-elf-as
LD	= $(GENDEV)/bin/m68k-elf-ld

READELF = $(GENDEV)/bin/m68k-elf-readelf
OBJDUMP = $(GENDEV)/bin/m68k-elf-objdump
DEBUGGER = $(GENDEV)/tools/blastem/blastem

ASFLAGS = -m68000 --register-prefix-optional 
LDFLAGS = -O1 -static -nostdlib  

OBJS 	= neozeed.o 

ROM 	= neozeed
BIN     = $(ROM).bin

all:	$(BIN) symbols dump

clean: 
	rm -rf $(BIN) $(shell find . -name '*.o')  && rm *.elf $(ROM).dump symbols.txt || true

$(BIN): $(OBJS)
	$(LD) $(LDFLAGS) $< --oformat binary -o $@

%.o: %.asm 
	@echo "AS $<"
	@$(AS) $(ASFLAGS) $< -o $@
	
symbols: $(OBJS)
	$(READELF) --symbols $< > symbols.txt

# We can get more info if we get memory dump from an elf.
dump: 
	$(OBJCOPY) -B m68k -I binary -O elf32-m68k $(BIN) $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) --oformat elf32-m68k -o $(ROM).elf
	$(OBJDUMP) --disassemble-all --target=elf32-m68k --architecture=m68k:68000 \
		--start-address=0x0000 --prefix-addresses -l -x $(ROM).elf > $(ROM).dump
		
run:
	$(DEBUGGER) $(BIN)  

	


