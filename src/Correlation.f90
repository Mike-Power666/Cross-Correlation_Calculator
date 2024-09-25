!------------------------------------------------------------------------------
! Memorial University of Newfoundland, MSc Student
!------------------------------------------------------------------------------
!
! MODULE: Correlation
!
!> @Mike-Power666
!> Michael Power
!
! DESCRIPTION: 
!> This module controls the calculation, normalization, and data output of the
!> cross-correlation function. It is parallelized for OpenMP.
!
! REVISION HISTORY:
! 26/06/2024 - Initial Version
!------------------------------------------------------------------------------

module Correlation_Module
    use Data_Output_Module
    use OMP_Lib
    use Load_Data_Module
    use Normalization_Module
    implicit none
    real(8), dimension(:), allocatable :: tau, C
    integer :: tau_max_index

contains

    subroutine Correlation(tau_start, tau_end, tau_step)
        use Romberg_Module

        real(8), intent(in) :: tau_start, tau_end, tau_step
        integer :: j
        real(8) :: tau_in_seconds, t_start, t_end, maxerror
        real(8), dimension(:), allocatable :: temp_array

        ! Initialize start and end times of the integral.
        t_start = 3.333333d11   !t(1)
        t_end = t(nmax)

        ! Initialize a maximum error for the integration.
        maxerror = 1.0d-5

        ! Calculate tau_max_index, the number of entries for the tau and C arrays.
        tau_max_index = int((tau_end - tau_start) / tau_step) + 1

        ! Allocate memory for tau and C arrays
        allocate(tau(tau_max_index), C(tau_max_index))

        ! Calculate tau and C arrays
        !$omp parallel do private(j, tau_in_seconds) shared(tau, C)
        do j = 1, tau_max_index
            tau_in_seconds = (tau_start + real(j-1, kind=8) * tau_step) * 2.4d1 * 3.6d3 ! Convert tau to seconds.
            tau(j) = tau_in_seconds
            ! Call Romberg module here to calculate C(j).
            call Romberg(t_start, t_end, maxerror, 2, tau(j), C(j))
        end do
        !$omp end parallel do

        ! Calculate the statistically normalized Correlation function.
        allocate(temp_array(tau_max_index))
        call Normalization(C, tau, tau_max_index, temp_array)
        
        ! Call Data_Output to prepare a file for plotting.
        call Data_Output(tau, temp_array, 'Cross_Correlation_Data.txt')
        deallocate(temp_array)

    end subroutine Correlation

end module Correlation_Module