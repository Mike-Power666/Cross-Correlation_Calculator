# Cross-Correlation_Calculator
 A very inefficient cross-correlation calculator, with not-so-good code structure!

I'm more or less uploading this for the individual pieces of the code, as opposed to the whole. It works very well, it was just made very rapidly to brute force a problem!

To run the code, navigate to the directory /src, then just type ./Compile_and_run.sh. This assumes you have gfortran installed on your system and also be aware, the code will try to use all of the cores on your system. 

The integrand file is where you will have to edit the integrands for your own, if someone were to ever actually use this. Also, the data folder would of course have to be present as well, else, you'd be trying to cross-correlate a file that doesn't exist with a mass-loss rate model for the star V CVn. Again, why I think the individual files, or at least the integration block is far more useful than the entire code!

Structure:
cross-correlation_calculator/
├── src/                       # Source code directory
│   ├── Binary_Search.f90      # Binary search routine
│   ├── Correlation.f90        # Correlation calculations
│   ├── Cross_Correlation.f90  # Main program
│   ├── Data_Out.f90           # Output results to file
│   ├── Linear_Int.f90         # Linear interpolation routine
│   ├── Integrand.f90          # Integrand calculations
│   ├── Load_Data.f90          # Data loading module
│   ├── Normalization.f90      # Normalization of results
│   └── Romberg.f90            # Romberg integration routine
├── tests/                     # Test directory
│   ├── test_correlation.f90   # Unit test for cross-correlation
├── README.md                  # Project description and instructions
├── .gitignore                 # Files to ignore
└── LICENSE                    # License file