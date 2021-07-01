SRC_DIRECTORY=src
BIN_DIRECTORY=bin
DOC_DIRECTORY=doc

C_DIRECTORY=C
FORTRAN_DIRECTORY=FORTRAN

SMALL_PARTIAL=168
SMALL_PARTIAL_HYBRID=336
SMALL_GLOBAL=672
SMALL_DEFINES=-DROWS=$(SMALL_GLOBAL) -DCOLUMNS=$(SMALL_GLOBAL)
SMALL_DEFINES_MPI_C=-DROWS=$(SMALL_PARTIAL) -DROWS_GLOBAL=$(SMALL_GLOBAL) -DCOLUMNS=$(SMALL_GLOBAL)
SMALL_DEFINES_MPI_FORTRAN=-DROWS=$(SMALL_GLOBAL) -DCOLUMNS_GLOBAL=$(SMALL_GLOBAL) -DCOLUMNS=$(SMALL_PARTIAL)
SMALL_DEFINES_HYBRID_C=-DROWS=$(SMALL_PARTIAL_HYBRID) -DROWS_GLOBAL=$(SMALL_GLOBAL) -DCOLUMNS=$(SMALL_GLOBAL)
SMALL_DEFINES_HYBRID_FORTRAN=-DROWS=$(SMALL_GLOBAL) -DCOLUMNS_GLOBAL=$(SMALL_GLOBAL) -DCOLUMNS=$(SMALL_PARTIAL_HYBRID)

BIG_PARTIAL=130
BIG_PARTIAL_HYBRID=1820
BIG_GLOBAL=14560
BIG_DEFINES=-DROWS=$(BIG_GLOBAL) -DCOLUMNS=$(BIG_GLOBAL)
BIG_DEFINES_MPI_C=-DROWS=$(BIG_PARTIAL) -DROWS_GLOBAL=$(BIG_GLOBAL) -DCOLUMNS=$(BIG_GLOBAL)
BIG_DEFINES_MPI_FORTRAN=-DROWS=$(BIG_GLOBAL) -DCOLUMNS_GLOBAL=$(BIG_GLOBAL) -DCOLUMNS=$(BIG_PARTIAL)
BIG_DEFINES_HYBRID_C=-DROWS=$(BIG_PARTIAL_HYBRID) -DROWS_GLOBAL=$(BIG_GLOBAL) -DCOLUMNS=$(BIG_GLOBAL)
BIG_DEFINES_HYBRID_FORTRAN=-DROWS=$(BIG_GLOBAL) -DCOLUMNS_GLOBAL=$(BIG_GLOBAL) -DCOLUMNS=$(BIG_PARTIAL_HYBRID)

CC=$(PREP) pgcc
MPICC=$(PREP) mpicc
CFLAGS=-c99 -fastsse -lm
PGICFLAGS=-c99 -fastsse -acc

FORTRANC=$(PREP) pgf90
MPIF90=$(PREP) mpif90
FORTRANFLAGS=-fastsse
PGIFORTRANFLAGS=-fastsse -acc

default: quick_compile

all: help documentation quick_compile 

quick_compile: verify_modules help create_directories serial_versions openmp_versions mpi_versions hybrid_cpu_versions openacc_versions hybrid_gpu_versions clean_objects

################
# SERIAL CODES #
################
serial_versions: print_serial_compilation C_serial_small C_serial_big FORTRAN_serial_small FORTRAN_serial_big

print_serial_compilation:
	@echo -e "\n/////////////////////////////"; \
	 echo "// COMPILING SERIAL CODES //"; \
	 echo "///////////////////////////";

C_serial_small: $(SRC_DIRECTORY)/$(C_DIRECTORY)/serial.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c
	@echo -e "    - [C] Small-grid version ($(SMALL_GLOBAL)x$(SMALL_GLOBAL))\n        \c";
	$(CC) -o $(BIN_DIRECTORY)/$(C_DIRECTORY)/serial_small $(SRC_DIRECTORY)/$(C_DIRECTORY)/serial.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c $(CFLAGS) $(SMALL_DEFINES) -DVERSION_RUN=\"serial_small\"

C_serial_big: $(SRC_DIRECTORY)/$(C_DIRECTORY)/serial.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c
	@echo -e "    - [C] Big-grid version ($(BIG_GLOBAL)x$(BIG_GLOBAL))\n        \c";
	$(CC) -o $(BIN_DIRECTORY)/$(C_DIRECTORY)/serial_big $(SRC_DIRECTORY)/$(C_DIRECTORY)/serial.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c $(CFLAGS) $(BIG_DEFINES) -DVERSION_RUN=\"serial_big\"

FORTRAN_serial_small: $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/serial.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90
	@echo -e "    - [FORTRAN] Small-grid version ($(SMALL_GLOBAL)x$(SMALL_GLOBAL))\n        \c";
	$(FORTRANC) $(SMALL_DEFINES) -o $(BIN_DIRECTORY)/$(FORTRAN_DIRECTORY)/serial_small $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/serial.F90 $(FORTRANFLAGS)  -DVERSION_RUN=\"serial_small\"

FORTRAN_serial_big: $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/serial.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90
	@echo -e "    - [FORTRAN] Big-grid version ($(BIG_GLOBAL)x$(BIG_GLOBAL))\n        \c";
	$(FORTRANC) $(BIG_DEFINES) -o $(BIN_DIRECTORY)/$(FORTRAN_DIRECTORY)/serial_big $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/serial.F90 $(FORTRANFLAGS) -DVERSION_RUN=\"serial_big\"

################
# OPENMP CODES #
################
openmp_versions: print_openmp_compilation C_openmp_small C_openmp_big FORTRAN_openmp_small FORTRAN_openmp_big

print_openmp_compilation:
	@echo -e "\n/////////////////////////////"; \
	 echo "// COMPILING OPENMP CODES //"; \
	 echo "///////////////////////////";

C_openmp_small: $(SRC_DIRECTORY)/$(C_DIRECTORY)/openmp.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c
	@echo -e "    - [C] Small-grid version ($(SMALL_GLOBAL)x$(SMALL_GLOBAL))\n        \c";
	$(CC) -o $(BIN_DIRECTORY)/$(C_DIRECTORY)/openmp_small $(SRC_DIRECTORY)/$(C_DIRECTORY)/openmp.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c $(CFLAGS) $(SMALL_DEFINES) -DVERSION_RUN=\"openmp_small\" -mp

C_openmp_big: $(SRC_DIRECTORY)/$(C_DIRECTORY)/openmp.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c
	@echo -e "    - [C] Big-grid version ($(BIG_GLOBAL)x$(BIG_GLOBAL))\n        \c";
	$(CC) -o $(BIN_DIRECTORY)/$(C_DIRECTORY)/openmp_big $(SRC_DIRECTORY)/$(C_DIRECTORY)/openmp.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c $(CFLAGS) $(BIG_DEFINES) -DVERSION_RUN=\"openmp_big\" -mp

FORTRAN_openmp_small: $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/openmp.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90
	@echo -e "    - [FORTRAN] Small-grid version ($(SMALL_GLOBAL)x$(SMALL_GLOBAL))\n        \c";
	$(FORTRANC) -o $(BIN_DIRECTORY)/$(FORTRAN_DIRECTORY)/openmp_small $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/openmp.F90 $(FORTRANFLAGS) $(SMALL_DEFINES) -DVERSION_RUN=\"openmp_small\" -mp

FORTRAN_openmp_big: $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/openmp.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90
	@echo -e "    - [FORTRAN] Big-grid version ($(BIG_GLOBAL)x$(BIG_GLOBAL))\n        \c";
	$(FORTRANC) -o $(BIN_DIRECTORY)/$(FORTRAN_DIRECTORY)/openmp_big $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/openmp.F90 $(FORTRANFLAGS) $(BIG_DEFINES) -DVERSION_RUN=\"openmp_big\" -mp

#############
# MPI CODES #
#############
mpi_versions: print_mpi_compilation C_mpi_small C_mpi_big FORTRAN_mpi_small FORTRAN_mpi_big

print_mpi_compilation:
	@echo -e "\n//////////////////////////"; \
	 echo "// COMPILING MPI CODES //"; \
	 echo "////////////////////////";

C_mpi_small: $(SRC_DIRECTORY)/$(C_DIRECTORY)/mpi.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c
	@echo -e "    - [C] Small-grid version ($(SMALL_GLOBAL)x$(SMALL_GLOBAL))\n        \c";
	$(MPICC) -o $(BIN_DIRECTORY)/$(C_DIRECTORY)/mpi_small $(SRC_DIRECTORY)/$(C_DIRECTORY)/mpi.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c $(CFLAGS) $(SMALL_DEFINES_MPI_C) -DVERSION_RUN=\"mpi_small\" -DVERSION_RUN_IS_MPI

C_mpi_big: $(SRC_DIRECTORY)/$(C_DIRECTORY)/mpi.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c
	@echo -e "    - [C] Big-grid version ($(BIG_GLOBAL)x$(BIG_GLOBAL))\n        \c";
	$(MPICC) -o $(BIN_DIRECTORY)/$(C_DIRECTORY)/mpi_big $(SRC_DIRECTORY)/$(C_DIRECTORY)/mpi.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c $(CFLAGS) $(BIG_DEFINES_MPI_C) -DVERSION_RUN=\"mpi_big\" -DVERSION_RUN_IS_MPI

FORTRAN_mpi_small: $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/mpi.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90
	@echo -e "    - [FORTRAN] Small-grid version ($(SMALL_GLOBAL)x$(SMALL_GLOBAL))\n        \c";
	$(MPIF90) -o $(BIN_DIRECTORY)/$(FORTRAN_DIRECTORY)/mpi_small $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/mpi.F90 $(FORTRANFLAGS) $(SMALL_DEFINES_MPI_FORTRAN) -DVERSION_RUN=\"mpi_small\" -DVERSION_RUN_IS_MPI

FORTRAN_mpi_big: $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/mpi.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90
	@echo -e "    - [FORTRAN] Big-grid version ($(BIG_GLOBAL)x$(BIG_GLOBAL))\n        \c";
	$(MPIF90) -o $(BIN_DIRECTORY)/$(FORTRAN_DIRECTORY)/mpi_big $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/mpi.F90 $(FORTRANFLAGS) $(BIG_DEFINES_MPI_FORTRAN) -DVERSION_RUN=\"mpi_big\" -DVERSION_RUN_IS_MPI

####################
# HYBRID CPU CODES #
####################
hybrid_cpu_versions: print_hybrid_cpu_compilation C_hybrid_cpu_small C_hybrid_cpu_big FORTRAN_hybrid_cpu_small FORTRAN_hybrid_cpu_big

print_hybrid_cpu_compilation:
	@echo -e "\n/////////////////////////////////"; \
	 echo "// COMPILING HYBRID CPU CODES //"; \
	 echo "///////////////////////////////";

C_hybrid_cpu_small: $(SRC_DIRECTORY)/$(C_DIRECTORY)/hybrid_cpu.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c
	@echo -e "    - [C] Small-grid version ($(SMALL_GLOBAL)x$(SMALL_GLOBAL))\n        \c";
	$(MPICC) -o $(BIN_DIRECTORY)/$(C_DIRECTORY)/hybrid_cpu_small $(SRC_DIRECTORY)/$(C_DIRECTORY)/hybrid_cpu.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c $(CFLAGS) $(SMALL_DEFINES_HYBRID_C) -mp -DVERSION_RUN=\"hybrid_cpu_small\" -DVERSION_RUN_IS_MPI

C_hybrid_cpu_big: $(SRC_DIRECTORY)/$(C_DIRECTORY)/hybrid_cpu.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c
	@echo -e "    - [C] Big-grid version ($(BIG_GLOBAL)x$(BIG_GLOBAL))\n        \c";
	$(MPICC) -o $(BIN_DIRECTORY)/$(C_DIRECTORY)/hybrid_cpu_big $(SRC_DIRECTORY)/$(C_DIRECTORY)/hybrid_cpu.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c $(CFLAGS) $(BIG_DEFINES_HYBRID_C) -mp -DVERSION_RUN=\"hybrid_cpu_big\" -DVERSION_RUN_IS_MPI

FORTRAN_hybrid_cpu_small: $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/hybrid_cpu.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90
	@echo -e "    - [FORTRAN] Small-grid version ($(SMALL_GLOBAL)x$(SMALL_GLOBAL))\n        \c";
	$(MPIF90) -o $(BIN_DIRECTORY)/$(FORTRAN_DIRECTORY)/hybrid_cpu_small $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/hybrid_cpu.F90 $(FORTRANFLAGS) $(SMALL_DEFINES_HYBRID_FORTRAN) -mp -DVERSION_RUN=\"hybrid_cpu_small\" -DVERSION_RUN_IS_MPI

FORTRAN_hybrid_cpu_big: $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/hybrid_cpu.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90
	@echo -e "    - [FORTRAN] Big-grid version ($(BIG_GLOBAL)x$(BIG_GLOBAL))\n        \c";
	$(MPIF90) -o $(BIN_DIRECTORY)/$(FORTRAN_DIRECTORY)/hybrid_cpu_big $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/hybrid_cpu.F90 $(FORTRANFLAGS) $(BIG_DEFINES_HYBRID_FORTRAN) -mp -DVERSION_RUN=\"hybrid_cpu_big\" -DVERSION_RUN_IS_MPI

#################
# OPENACC CODES #
#################
openacc_versions: print_openacc_compilation C_openacc_small C_openacc_big FORTRAN_openacc_small FORTRAN_openacc_big

print_openacc_compilation:
	@echo -e "\n//////////////////////////////"; \
	 echo "// COMPILING OPENACC CODES //"; \
	 echo "////////////////////////////";

C_openacc_small: $(SRC_DIRECTORY)/$(C_DIRECTORY)/openacc.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c
	@echo -e "    - [C] Small-grid version ($(SMALL_GLOBAL)x$(SMALL_GLOBAL))\n        \c";
	$(CC) -o $(BIN_DIRECTORY)/$(C_DIRECTORY)/openacc_small $(SRC_DIRECTORY)/$(C_DIRECTORY)/openacc.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c $(PGICFLAGS) $(SMALL_DEFINES) -DVERSION_RUN=\"openacc_small\"

C_openacc_big: $(SRC_DIRECTORY)/$(C_DIRECTORY)/openacc.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c
	@echo -e "    - [C] Big-grid version ($(BIG_GLOBAL)x$(BIG_GLOBAL))\n        \c";
	$(CC) -o $(BIN_DIRECTORY)/$(C_DIRECTORY)/openacc_big $(SRC_DIRECTORY)/$(C_DIRECTORY)/openacc.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c $(PGICFLAGS) $(BIG_DEFINES) -DVERSION_RUN=\"openacc_big\"

FORTRAN_openacc_small: $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/openacc.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90
	@echo -e "    - [FORTRAN] Small-grid version ($(SMALL_GLOBAL)x$(SMALL_GLOBAL))\n        \c";
	$(FORTRANC) -o $(BIN_DIRECTORY)/$(FORTRAN_DIRECTORY)/openacc_small $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/openacc.F90 $(PGIFORTRANFLAGS) $(SMALL_DEFINES) -DVERSION_RUN=\"openacc_small\"

FORTRAN_openacc_big: $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/openacc.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90
	@echo -e "    - [FORTRAN] Big-grid version ($(BIG_GLOBAL)x$(BIG_GLOBAL))\n        \c";
	$(FORTRANC) -o $(BIN_DIRECTORY)/$(FORTRAN_DIRECTORY)/openacc_big $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/openacc.F90 $(PGIFORTRANFLAGS) $(BIG_DEFINES) -DVERSION_RUN=\"openacc_big\"

####################
# HYBRID GPU CODES #
####################
hybrid_gpu_versions: print_hybrid_gpu_compilation C_hybrid_gpu_small C_hybrid_gpu_big FORTRAN_hybrid_gpu_small FORTRAN_hybrid_gpu_big

print_hybrid_gpu_compilation:
	@echo -e "\n/////////////////////////////////"; \
	 echo "// COMPILING HYBRID GPU CODES //"; \
	 echo "///////////////////////////////";

C_hybrid_gpu_small: $(SRC_DIRECTORY)/$(C_DIRECTORY)/hybrid_gpu.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c
	@echo -e "    - [C] Small-grid version ($(SMALL_GLOBAL)x$(SMALL_GLOBAL))\n        \c";
	$(MPICC) -o $(BIN_DIRECTORY)/$(C_DIRECTORY)/hybrid_gpu_small $(SRC_DIRECTORY)/$(C_DIRECTORY)/hybrid_gpu.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c $(PGICFLAGS) $(SMALL_DEFINES_HYBRID_C) -mp -DVERSION_RUN=\"hybrid_gpu_small\" -DVERSION_RUN_IS_MPI

C_hybrid_gpu_big: $(SRC_DIRECTORY)/$(C_DIRECTORY)/hybrid_gpu.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c
	@echo -e "    - [C] Big-grid version ($(BIG_GLOBAL)x$(BIG_GLOBAL))\n        \c";
	$(MPICC) -o $(BIN_DIRECTORY)/$(C_DIRECTORY)/hybrid_gpu_big $(SRC_DIRECTORY)/$(C_DIRECTORY)/hybrid_gpu.c $(SRC_DIRECTORY)/$(C_DIRECTORY)/util.c $(PGICFLAGS) $(BIG_DEFINES_HYBRID_C) -mp -DVERSION_RUN=\"hybrid_gpu_big\" -DVERSION_RUN_IS_MPI -Wl,-z,noexecstack

FORTRAN_hybrid_gpu_small: $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/hybrid_gpu.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90
	@echo -e "    - [FORTRAN] Small-grid version ($(SMALL_GLOBAL)x$(SMALL_GLOBAL))\n        \c";
	$(MPIF90) -o $(BIN_DIRECTORY)/$(FORTRAN_DIRECTORY)/hybrid_gpu_small $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/hybrid_gpu.F90 $(PGIFORTRANFLAGS) $(SMALL_DEFINES_HYBRID_FORTRAN) -mp -DVERSION_RUN=\"hybrid_gpu_small\" -DVERSION_RUN_IS_MPI

FORTRAN_hybrid_gpu_big: $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/hybrid_gpu.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90
	@echo -e "    - [FORTRAN] Big-grid version ($(BIG_GLOBAL)x$(BIG_GLOBAL))\n        \c";
	$(MPIF90) -o $(BIN_DIRECTORY)/$(FORTRAN_DIRECTORY)/hybrid_gpu_big $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/util.F90 $(SRC_DIRECTORY)/$(FORTRAN_DIRECTORY)/hybrid_gpu.F90 $(PGIFORTRANFLAGS) $(BIG_DEFINES_HYBRID_FORTRAN) -mp -DVERSION_RUN=\"hybrid_gpu_big\" -DVERSION_RUN_IS_MPI -Wl,-z,noexecstack

clean_objects:
	@rm -f *.o *.mod;

#############
# UTILITIES #
#############
verify_modules:
	@if ! type "pgcc" > /dev/null 2>&1; then \
		clear; \
		echo -e "\n    . "; \
		echo -e "   / \\"; \
		echo -e "  / ! \\  It looks like the PGI compiler is not loaded."; \
		echo -e " /_____\\ On Bridges please issue 'module load cuda/9.2 mpi/pgi_openmpi/19.4-nongpu'. You can now make again :)\n"; \
		exit -1; \
	fi

create_directories:
	@if [ ! -d $(BIN_DIRECTORY) ]; then mkdir $(BIN_DIRECTORY); fi; \
	if [ ! -d $(BIN_DIRECTORY)/$(C_DIRECTORY) ]; then mkdir $(BIN_DIRECTORY)/$(C_DIRECTORY); fi; \
	if [ ! -d $(BIN_DIRECTORY)/$(FORTRAN_DIRECTORY) ]; then mkdir $(BIN_DIRECTORY)/$(FORTRAN_DIRECTORY); fi 

help:
	@clear; \
	echo "+-----------+"; \
	echo "| Quick help \\"; \
	echo "+-------------+------------------+--------------------+"; \
	echo "| Generate the documentation     | make documentation |"; \
	echo "| Delete all binaries            | make clean         |"; \
	echo -e "+-----------------------------------------------------+\n";

clean: help
	@echo -e "\n////////////////////////";
	@echo "// CLEANING BINARIES //";
	@echo "//////////////////////";
	rm -rf $(BIN_DIRECTORY);

documentation: help
	@echo -e "\n///////////////////////////////";
	@echo "// GENERATING DOCUMENTATION //";
	@echo "/////////////////////////////";
	@echo -e "    - Generating doxygen... \c"; \
	 doxygen > /dev/null 2>&1; \
	 echo "done"; \
	 echo "    - The HTML documentation is available in 'doc/html/index.xhtml'."; \
