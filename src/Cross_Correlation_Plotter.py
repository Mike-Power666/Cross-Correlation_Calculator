#------------------------------------------------------------------------------
# Memorial University of Newfoundland, MSc Student
#------------------------------------------------------------------------------
#
# Program: Cross_Correlation_Plotter
#
#> @Mike-Power666
#> Michael Power
#
# DESCRIPTION: 
#> This program simply plots a normalized cross-correlation function and finds
#> a local minima.
#
# REVISION HISTORY:
# 29/06/2024 - Initial Version
#------------------------------------------------------------------------------

import numpy as np
import matplotlib.pyplot as plt

# Function to read data from the file.
def read_data(filename):
    data = np.loadtxt(filename)
    tau = data[:, 0] / (24 * 3600) # Convert lag time back to days.
    C = data[:, 1]
    return tau, C

# Function to find the index of the local minimum near zero.
def find_local_minima(tau, C):
    zero_index = np.argmin(np.abs(tau))  # Find the index closest to zero
    window_size = 100  # Adjust the window size as needed
    window_start = max(0, zero_index - window_size)
    window_end = min(len(tau), zero_index + window_size)
    local_min_index = window_start + np.argmin(C[window_start:window_end])
    
    local_min_tau = tau[local_min_index]
    local_min_C = C[local_min_index]
    print(f"Local minimum near zero found at τ = {local_min_tau:.15f}, Ć(τ) = {local_min_C:.15f}")
    
    return float(local_min_tau), float(local_min_C)

# Plotting function.
def plot_data(tau, C, output_file):
    plt.rcParams['text.usetex'] = True  # Enable LaTeX rendering.
    plt.rcParams['font.size'] = 12  # Set default font size for tick marks.
    plt.rcParams['axes.labelsize'] = 20  # Set font size for labels.
    
    plt.figure(figsize=(10, 6))
    plt.plot(tau, C, label=r'$\hat{C}(\tau)$')
    plt.xlabel(r'$\tau$')
    plt.ylabel(r'$\hat{C}(\tau)$')
    plt.grid(True)
    
    # Find and plot the local minimum near zero.
    local_min_tau, local_min_C = find_local_minima(tau, C)
    plt.axvline(x=local_min_tau, color='red', linestyle='--', label='Local Minima Near Zero')   
    plt.savefig(output_file, format='png')

# Main function.
def main():
    input_file = 'Cross_Correlation_Data.txt'
    output_file = 'Cross_Correlation_Plot.png'
    
    tau, C = read_data(input_file)
    plot_data(tau, C, output_file)

if __name__ == "__main__":
    main()