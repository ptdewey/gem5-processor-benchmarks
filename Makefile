.PHONY: build debug clean dir

all: build

dir:
	@mkdir -p build

build: dir
	@find src/Benchmarks -type f -name '*.c' -exec sh -c 'gcc {} -o build/`basename {} .c`' \;

debug: dir
	# NOTE: can add -Wall -Wextra -Werror if desired
	@find src/Benchmarks -type f -name '*.c' -exec sh -c 'gcc -g -DDEBUG=1 {} -o build/`basename {} .c`' \;

clean:
	rm -rf build
