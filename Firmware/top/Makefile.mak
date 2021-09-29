PROJ = top
TOPLEVEL = top
DEVICE = hx8k
PACKAGE = ct256
PIN_DEF = top.pcf

build/%.json: %.v
	IF NOT EXIST build mkdir build
	yosys -l build/$(PROJ).log -p 'synth_ice40 -top $(TOPLEVEL) -json $@' $<

build/%.asc: build/%.json
	nextpnr-ice40.exe --$(DEVICE) --json $< --pcf $(PIN_DEF) --asc $@ --package $(PACKAGE) --log build/$(PROJ).tim --ignore-loops

build/%.rpt: build/%.asc
	icetime -d $(DEVICE) -mtr $@ $<

build/%.bin: build/%.asc
	icepack $< $@

.PHONY: prog_sram
prog_sram: build/$(PROJ).bin
	iceprog -S $<

.PHONY: prog_flash
prog_flash: build/$(PROJ).bin
	iceprog $<

# ---- Tasks ----

synth: build/$(PROJ).json
pnr: build/$(PROJ).asc
time: build/$(PROJ).rpt
pack: build/$(PROJ).bin
.PHONY: prog
prog: prog_sram

# ---- Clean ----

.PHONY: clean
clean:
	del /Q build