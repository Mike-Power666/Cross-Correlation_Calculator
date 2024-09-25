!------------------------------------------------------------------------------
! Memorial University of Newfoundland, MSc Student
!------------------------------------------------------------------------------
!
! PROGRAM: Cross_Correlation 
!
!> @Mike-Power666
!> Michael Power
!
! DESCRIPTION: 
!> This is the main program to execute the steps to calculate a 
!> cross-correlation function between the polarization signal of V CVn and
!> its mass-loss rate.
!
! REVISION HISTORY:
! 25/06/2024 - Initial Version
!------------------------------------------------------------------------------

program Cross_Correlation
    use Load_Data_Module
    use Correlation_Module
    implicit none

    real(8) :: tau_start, tau_end, tau_step

    ! Call Load_Data, giving access to the Thomson arrays.
    call Load_Data('ThomsonScattering_tr.txt')

    ! Initialize the lags at which to calculate the cross-correlation function (in days).
    tau_start = -195.0d0
    tau_end   =  195.0d0
    tau_step  =    2.5d-1

    ! Call Correlation begin the calculation.
    call Correlation(tau_start, tau_end, tau_step)
    
end program Cross_Correlation