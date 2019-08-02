# Practice 01 Toolchain

# What is a toolchain
A toolchain is a set of tools with the main purpose of generate/compile
code for an specific hardware architecture.

# Compiler

## GNU compiler

# Main components
"
* Binutils: A set of binary utilities including the assembler and the linker. 
It is available at http://www.gnu.org/software/binutils.
* GNU Compiler Collection (GCC): These are the compilers for C and other languages
which, depending on the version of GCC, include C++, Objective-C, Objective-C++,
Java, Fortran, Ada, and Go. They all use a common backend which produces assembler
code, which is fed to the GNU assembler. It is available at http://gcc.gnu.org/.
* C library: A standardized application program interface (API) based on the POSIX
specification, which is the main interface to the operating system kernel for applications.
There are several C libraries to consider, as we shall see later on in this chapter.
* Kernel Headers: Definitions and constants that are needed when accessing the kernel directly.
* GNU Debugger
"

# Toolchain types
"
* Native: This toolchain runs on the same type of system (sometimes the same actual system)
as the programs it generates. This is the usual case for desktops and servers, and it is
becoming popular on certain classes of embedded devices. The Raspberry Pi running Debian for ARM,
for example, has self-hosted native compilers.
* Cross: This toolchain runs on a different type of system than the target, allowing the
development to be done on a fast desktop PC and then loaded onto the embedded target for testing.
"

Working with Crosscompilers helps to isolate development environment from the host,
I consider it an advantage due to most of embedded devices are strongly limited on
resources as CPU, memory, power consumption.

### GNU vs Clang compiler
"
There are some technical advantages to Clang as well, such as faster compilation
and better diagnostics, but GNU GCC has the advantage of compatibility with the
existing code base and support for a wide range of architectures and operating systems.
Indeed, there are still some areas where Clang cannot replace the GNU C compiler,
especially when it comes to compiling a mainline Linux kernel.
It is probable that, in the next year or so, Clang will be able to compile all the
components needed for embedded Linux and so will become an alternative to GNU.
"
# Toolchain requirements
1. CPU architecture
2. Big- or little-endian operation
3. Floating point support
4. pplication Binary Interface (ABI)

# References
Chris Simmonds,Mastering Embedded Linux Programming - Second Edition [2017]. Packt Publishing
