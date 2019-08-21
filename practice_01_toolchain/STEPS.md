# Steps to create Toolchain

# Board specs [raspberry pi 3 model B](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/)
SOC: BCM2837
Processor: ARM Cortex-A53
Microarchitecture: 	ARMv8-A
FPU: neon-vfpv4

## 1. Download tools
- [Binutils](https://www.gnu.org/software/binutils/): Collection of binary tools as linker and assembler.
- [BusyBox](http://www.busybox.net): combines tiny versions of many common UNIX utilities into a single
small executable. It provides replacements for most of the utilities you usually find in GNU fileutils, shellutils, etc.
- [gcc]( http://gcc.gnu.org): GNU Compiler Collection
- [gmp](https://gmplib.org/): GMP is a free library for arbitrary precision arithmetic,
  operating on signed integers, rational numbers, and floating-point numbers.
- [iana](http://sethwklein.net/iana-etc): The iana-etc package provides the Unix/Linux /etc/services and /etc/protocols files
- [linux_kernel](http://www.kernel.org):
- [mpc](http://www.multiprecision.org/mpc/):C library for the arithmetic of complex numbers with
  arbitrarily high precision and correct rounding of the result. It extends the principles of the
  IEEE-754 standard for fixed precision real floating point numbers to complex numbers
- [mpfr](http://www.mpfr.org/): C library for multiple-precision floating-point computations with correct rounding.
- [musl](http://musl-libc.org/): libc

## 2. Install sanitized linux headers

## 3. Install binutils
It is important that Binutils be the first package compiled because both the C library and GCC perform
various tests on the available linker and assembler to determine which of their own features to enable.
The Binutils documentation recommends building Binutils outside of the source directory in a dedicated build directory:

## 4. GCC install c compiler
The GCC package contains the GNU compiler collection, which includes the C compiler. This build of GCC
is mainly done so that the C library can be built next.

## 5. libc
The musl package contains the main C library. This library provides the basic routines for allocating memory,
searching directories, opening and closing files, reading and writing files, string handling, pattern matching,
arithmetic, and so on.

## 6. GCC generate cross-compiler with libc libraries compiled at previous step
The GCC package contains the GNU compiler collection, which includes the C compiler.
This second build of GCC will produce the final cross compiler which will use the previously built C library.

# References
- https://clfs.org/view/clfs-embedded/arm/materials/packages.html

