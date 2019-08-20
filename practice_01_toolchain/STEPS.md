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
- [gmp](https://gmplib.org/): GMP is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating-point numbers.
- [iana](http://sethwklein.net/iana-etc): The iana-etc package provides the Unix/Linux /etc/services and /etc/protocols files
- [linux_kernel](http://www.kernel.org):
- [mpc](http://www.multiprecision.org/mpc/):C library for the arithmetic of complex numbers with arbitrarily high precision and correct rounding of the result. It extends the principles of the IEEE-754 standard for fixed precision real floating point numbers to complex numbers
- [mpfr](http://www.mpfr.org/): C library for multiple-precision floating-point computations with correct rounding.
- [musl](http://musl-libc.org/): libc

## 2. Install sanitized linux headers


# References
- https://clfs.org/view/clfs-embedded/arm/materials/packages.html

