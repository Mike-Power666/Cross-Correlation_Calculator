#------------------------------------------------------------------------------
# Memorial University of Newfoundland, MSc Student
#------------------------------------------------------------------------------
#
# Script: Cross_Correlation_Calculator
#
#> @Mike-Power666
#> Michael Power
#
# DESCRIPTION: 
#> This bash script compiles, executes, and then cleans up the directory
#> containing the cross-correlation function calculator. Note that it tries to
#> use all cores on a given machine, therefore caution is advised!
#
# REVISION HISTORY:
# 29/06/2024 - Initial Version
#------------------------------------------------------------------------------

#!/bin/bash

# Determine the number of CPU cores.
NUM_CORES=$(sysctl -n hw.physicalcpu)

# Export OMP_NUM_THREADS to use all available CPU cores.
export OMP_NUM_THREADS=$NUM_CORES

# Compile Fortran files with OpenMP and warnings enabled.
gfortran -fopenmp -Wall -Wextra -c Binary_Search.f90
gfortran -fopenmp -Wall -Wextra -c Data_Out.f90
gfortran -fopenmp -Wall -Wextra -c Linear_Int.f90
gfortran -fopenmp -Wall -Wextra -c Load_Data.f90
gfortran -fopenmp -Wall -Wextra -c Integrand.f90
gfortran -fopenmp -Wall -Wextra -c Romberg.f90
gfortran -fopenmp -Wall -Wextra -c Normalization.f90
gfortran -fopenmp -Wall -Wextra -c Correlation.f90
gfortran -fopenmp -Wall -Wextra -c Cross_Correlation.f90

# Check if compilation was successful before proceeding.
if [ $? -ne 0 ]; then
    echo "Compilation failed... Exiting."
    exit 1
fi

# Link object files with OpenMP and create executable.
gfortran -fopenmp Binary_Search.o Linear_Int.o Load_Data.o Integrand.o Romberg.o Correlation.o Data_Out.o Normalization.o Cross_Correlation.o -o Cross_Correlation_Calculator

# Check if linking was successful before proceeding.
if [ $? -ne 0 ]; then
    echo "Linking failed.... Exiting."
    exit 1
fi

# Run the executable.
./Cross_Correlation_Calculator

# Clean up object files and executable after running.
rm *.o Cross_Correlation_Calculator

# Run the python plotting script.
python Cross_Correlation_Plotter.py

echo "Execution and cleanup completed."