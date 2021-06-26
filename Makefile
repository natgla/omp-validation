# General Makefile containing all the necessary compiler flags for the tests

# modify CC and CFLAGS for OpenMP C compilers
# modify FC and FFLAGS for OpenMP Fortran compilers


# Content:
#########################################################

# 1. Basic usage
# 2. General testsuite settings
# 3. Compiler selection and Flags

#########################################################


#########################################################
# 1. Basic usage
#########################################################
# 	make ctest		generate c test "ctest"
# 	make ftest		generate fortran test "ftest"
#	make clean		removes all sources and binaries
# 	make cleanall	removes sources,binaries and logfiles


#########################################################
# 2. General testsuite settings
#########################################################

# For general testsuite settings see the configuration file
# ompts.conf

#########################################################
# 3. Compiler selection and Flags
#########################################################

# MSVC Compiler
CC     = cl
CFLAGS = -openmp:experimental -openmp:llvm -O2 -DWIN32 -D_WINDOWS -D_WIN32 -TP

# MSVC Compiler, old switch
#CC     = cl
#CFLAGS =-openmp -O2 -DWIN32 -D_WINDOWS -D_WIN32

# LLVM Compiler
#CC     = clang
#CFLAGS =-fopenmp -O3 -DWIN32 -D_WINDOWS -D_WIN32

#########################################################################

help:
	@echo "OpenMP Validation Suite, v3.0"
	@echo "(C) University of Stuttgart, University of Houston"
	@echo ""
	@echo "Do make [rule], where rule may be one of:"
	@echo "  ctest"
	@echo "    Build and run the OpenMP/C validation tests."
	@echo "  ftest"
	@echo "    Build and run the OpenMP/Fortran validation tests."
	@echo "  print_compile_options"
	@echo "    Display the default compiler and compiler options being tested"
	@echo "  cleansrcs"
	@echo "    Remove sources generated from the templates"
	@echo "  cleanbins"
	@echo "    Remove executables from bin/ directory"
	@echo "  cleanouts"
	@echo "    Remove all *.out files from bin/ directory"
	@echo "  cleanlogs"
	@echo "    Remove all *.log files from bin/ directory"
	@echo "  clean"
	@echo "    Remove all sources and executables from bin/ directory"
	@echo "  cleanall"
	@echo "    Remove the entire bin/ directory"

{bin\c\}.c{bin\c\}.exe:
# Space at the end of this command is intentional
	$(CC) $(CFLAGS) $< /I. /Fobin\c\ /Febin\c\ 

ctest: omp_my_sleep omp_testsuite omp_testsuite.h unistd
	perl runtest.pl --lang=c testlist-c.txt

print_compile_options:
	@echo "-------------------"
	@echo "C compiler"
	@echo "-------------------"
	@echo "compilation: $(CC) $(CFLAGS)"
	@$(CC)

clean:
	rd /s /q bin
	del omp_testsuite.h

.IGNORE:

unistd:
	if not exist "bin\c" mkdir bin\c
	copy unistd.h bin\c\ 
omp_my_sleep:
	if not exist "bin\c" mkdir bin\c
	copy omp_my_sleep.h bin\c\ 
omp_testsuite: omp_testsuite.h
	if not exist "bin\c" mkdir bin\c
	copy omp_testsuite.h bin\c\ 
omp_testsuite.h: ompts-c.conf c\*
	perl ompts_makeHeader.pl -f=ompts-c.conf -t=c

