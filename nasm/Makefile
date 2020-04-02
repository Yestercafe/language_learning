base    := asm_io.o driver.o
req     := $(base) asm_io.inc
cc      := gcc
ccflags := -m32 -w
na      := nasm
naflags := -f elf
bin     := first   math   prime   max   sub1   sub2   sub3
asmsobj := first.o math.o prime.o max.o sub1.o sub2.o sub3.o
all     := $(bin) *.o *.S main4 main5 array1c memex

project: $(bin) integer_extend_test.S main4 main5 array1c memex

$(bin): %: %.o $(req)
	$(cc) $(ccflags) $< $(base) -o $@

$(asmsobj): %.o: %.asm
	$(na) $(naflags) $<

main4: main4.o sub4.o $(base)
	$(cc) $(ccflags) main4.o sub4.o $(base) -o main4

main4.o: main4.asm $(req)
	$(na) $(naflags) main4.asm

sub4.o: sub4.asm $(req)
	$(na) $(naflags) sub4.asm

main5: main5.o sub5.o asm_io.o
	$(cc) $(ccflags) main5.o sub5.o asm_io.o -o $@

main5.o: main5.c
	$(cc) $(ccflags) -c $< -o $@

sub5.o: sub5.asm asm_io.o
	$(na) $(naflags) sub5.asm

array1c: array1c.o array1.o asm_io.o
	$(cc) $(ccflags) array1c.o array1.o asm_io.o -o $@

array1c.o: array1c.c
	$(cc) $(ccflags) -c $< -o $@

array1.o: array1.asm asm_io.o
	$(na) $(naflags) $<

memex: memex.o memory.o asm_io.o
	$(cc) $(ccflags) memex.o memory.o asm_io.o -o $@

memex.o: memex.c
	$(cc) $(ccflags) -c $< -o $@

memory.o: memory.asm asm_io.o
	$(na) $(naflags) $<

asm_io.o: asm_io.asm asm_io.inc
	$(na) $(naflags) -d ELF_TYPE asm_io.asm

driver.o: driver.c
	$(cc) $(ccflags) -c $< -o $@

integer_extend_test.S: integer_extend_test.c
	$(cc) -S $< -o $@

.PHONY:
clean:
	rm -f $(all)