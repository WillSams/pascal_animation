GENDEV=/opt/toolchains/m68k

AS	= $(GENDEV)/bin/m68k-unknown-elf-as
LD	= $(GENDEV)/bin/m68k-unknown-elf-ld

READELF  = $(GENDEV)/bin/m68k-unknown-elf-readelf
OBJDUMP  = $(GENDEV)/bin/m68k-unknown-elf-objdump
DEBUGGER = $(GENDEV)/tools/blastem/blastem

ASFLAGS = -m68000 --register-prefix-optional 
LDFLAGS = -O1 -static -nostdlib  

OBJS 	= neozeed.o 

ROM 	= neozeed
BIN   = $(ROM).bin

all:	$(BIN) symbols dump

clean: 
	rm -rf $(BIN) $(shell find . -name '*.o')  && rm *.elf $(ROM).dump symbols.txt || true

$(BIN): $(OBJS)
	$(LD) $(LDFLAGS) $< --oformat binary -o $@

%.o: %.s
	@echo "AS $<"
	@$(AS) $(ASFLAGS) $< -o $@
	
symbols: $(OBJS)
	$(READELF) --symbols $< > symbols.txt

# We can get more info if we get memory dump from an elf.
dump: 
	$(LD) $(LDFLAGS) $(OBJS) --oformat elf32-m68k -o $(ROM).elf
	$(OBJDUMP) --disassemble-all --target=elf32-m68k --architecture=m68k:68000 \
		--start-address=0x0000 --prefix-addresses -l -x $(ROM).elf > $(ROM).dump
		
run:
	$(DEBUGGER) $(BIN)  

	


