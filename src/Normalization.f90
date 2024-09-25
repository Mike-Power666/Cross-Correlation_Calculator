!------------------------------------------------------------------------------
! Memorial University of Newfoundland, MSc Student
!------------------------------------------------------------------------------
!
! MODULE: Normalization
!
!> @Mike-Power666
!> Michael Power
!
! DESCRIPTION: 
!> Calculates the statistical normalization of a cross-correlation function.
!> That is, Norm(C(tau)) = [C(tau) - mean(C(tau))] / sigma(C(tau)).
!> The mean and variance are calculated by virtue of a Romberg integrator.
!
! REVISION HISTORY:
! 28/06/2024 - Initial Version
!------------------------------------------------------------------------------

module Normalization_Module
    implicit none
    
contains

    subroutine Normalization(C, tau, tau_max_index, norm)
        use Romberg_Module
        real(8), dimension(:), allocatable, intent(in) :: C, tau
        integer, intent(in) :: tau_max_index
        real(8), dimension(tau_max_index), intent(out) :: norm 
        real(8) :: mean_of_C, variance_of_C

        ! Call Romberg to calculate the mean.
        call Romberg(tau(1), tau(tau_max_index), 1.0d-9, 3, 0.0d0, mean_of_C)

        ! Call Romberg to calculate the variance.
        call Romberg(tau(1), tau(tau_max_index), 1.0d-9, 4, mean_of_C, variance_of_C)

        ! Calculate the statistically normalized cross-correlation function.
        norm = (C - mean_of_C) / sqrt(variance_of_C)
        
    end subroutine Normalization
    
end module Normalization_Module