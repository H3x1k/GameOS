ASM = nasm
ASMFLAGS = -f bin
SRC = src/boot.asm
OUTDIR = build
OUTPUT = $(OUTDIR)/game.bin

all: $(OUTPUT)

$(OUTPUT): $(SRC)
	@if not exist $(OUTDIR) mkdir $(OUTDIR)
	$(ASM) $(ASMFLAGS) -o $@ $<

run: $(OUTPUT)
	qemu-system-i386 -fda $(OUTPUT)

clean:
	rm -f $(OUTPUT)