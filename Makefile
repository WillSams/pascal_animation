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
	rm -rf $(BIN) $(shell find . -name '*.o')  && rm -r $(ROM).dump symbols.txt || true

$(BIN): $(OBJS)
	$(LD) $(LDFLAGS) $< --oformat binary -o $@

%.o: %.asm 
	@echo "AS $<"
	@$(AS) $(ASFLAGS) $< -o $@
	
symbols: $(OBJS)
	$(READELF) --symbols $< > symbols.txt

dump: 
	$(OBJDUMP) --disassemble-all --target=binary --architecture=m68k \
		--start-address=0x0000 $(BIN) > $(ROM).dump
run:
	$(DEBUGGER) $(BIN)  

	


