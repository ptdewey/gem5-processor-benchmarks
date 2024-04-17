.PHONY: all clean

all:
	@./compile.sh

clean:
	@echo "Cleaning build directories..."
	@rm -rf build/X86 build/ARM
