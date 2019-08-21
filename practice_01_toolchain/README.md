# Practice 01 Toolchain

# What is a toolchain
A toolchain is a set of tools with the main purpose of generate/compile
code for an specific hardware architecture.

# Main components

* Binutils: A set of binary utilities including the assembler and the linker. 
It is available at http://www.gnu.org/software/binutils.
* GNU Compiler Collection (GCC): These are the compilers for C and other languages
which, depending on the version of GCC, include C++, Objective-C, Objective-C++,
Java, Fortran, Ada, and Go. They all use a common backend which produces assembler
code, which is fed to the GNU assembler. It is available at http://gcc.gnu.org/.
* C library: A standardized application program interface (API) based on the POSIX which funge
as bridge between Application and kernel space using kernel system calls interface.
* glibc: Standar GNU C library, with most complete implementation of POSIX API under LGPL 2.1.
* musl libc: alternative to GNU lib c, for systems with limited resources under MIT license. 
** uClibc-ng: uClibc-ng is a small C library for developing embedded Linux systems under LGPL 2.1.

According  to Chris Simmonds at Mastering Embedded Linux Programming - Second Edition, his advice
is to use uClibc-ng only if you are using uClinux. If you have very limited amount of storage or
RAM, then musl libc is a good choice, otherwise, use glibc.

* Kernel Headers: Definitions and constants that are needed when accessing the kernel directly.
* GNU Debugger


# Toolchain types

* Native: This toolchain runs on the same type of system (sometimes the same actual system)
as the programs it generates. This is the usual case for desktops and servers, and it is
becoming popular on certain classes of embedded devices. The Raspberry Pi running Debian for ARM,
for example, has self-hosted native compilers.
* Cross: This toolchain runs on a different type of system than the target, allowing the
development to be done on a fast desktop PC and then loaded onto the embedded target for testing.


Working with Crosscompilers helps to isolate development environment from the host,
I consider it an advantage due to most of embedded devices are strongly limited on
resources as CPU, memory, power consumption.

### GNU vs Clang compiler

There are some technical advantages to Clang as well, such as faster compilation
and better diagnostics, but GNU GCC has the advantage of compatibility with the
existing code base and support for a wide range of architectures and operating systems.
Indeed, there are still some areas where Clang cannot replace the GNU C compiler,
especially when it comes to compiling a mainline Linux kernel.
It is probable that, in the next year or so, Clang will be able to compile all the
components needed for embedded Linux and so will become an alternative to GNU.

# Toolchain requirements
1. CPU architecture
2. Big- or little-endian operation
3. Floating point support
4. pplication Binary Interface (ABI)

# Naming Crosscompiler
<cpu>-<vendor>-<kernel>-<OS>

example:
mipsel-unknown-linux-gnu-gcc

# Finding toolchain

* Create a toolchain from scratch as mentioned at http://trac.clfs.org
* Use alternative as crosstool-NG
* Use build system as buildroot or yocto

# sysroot directory
The toolchain sysroot is a directory which contains subdirectories for libraries, header files,
and other configuration files.

You will find the following subdirectories in sysroot:

* lib: Contains the shared objects for the C library and the dynamic linker/loader, ld-linux
* usr/lib, the static library archive files for the C library, and any other libraries that
may be installed subsequently
* usr/include: Contains the headers for all the libraries
* usr/bin: Contains the utility programs that run on the target, such as the ldd command
* use/share: Used for localization and internationalization
* sbin: Provides the ldconfig utility, used to optimize library loading paths

Chris Simmond: "So, which to choose? My advice is to use uClibc-ng only if you are using uClinux.
If you have very limited amount of storage or RAM, then musl libc is a good choice, otherwise, use glibc"

# Structure

    lib: Contains the shared objects for the C library and the dynamic linker/loader, ld-linux
    usr/lib, the static library archive files for the C library, and any other libraries that may be installed subsequently
    usr/include: Contains the headers for all the libraries
    usr/bin: Contains the utility programs that run on the target, such as the ldd command
    use/share: Used for localization and internationalization
    sbin: Provides the ldconfig utility, used to optimize library loading paths

# References
Chris Simmond, Mastering Embedded Linux Programming - Second Edition [2017]. Packt Publishing

