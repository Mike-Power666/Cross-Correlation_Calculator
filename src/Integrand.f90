!------------------------------------------------------------------------------
! Saint Mary's University, Honours Student
!------------------------------------------------------------------------------
!
! MODULE: Integrand
!
!> @Mike-Power666
!> Michael Power
!
! DESCRIPTION: 
!> The integrand calculator associated with a Romberg integration algorithm.
!
! REVISION HISTORY:
! 29/04/2017 - Initial Version
! 26/06/2024 - Revision 1
!> Refactored the original algorithm to be more modular and specialized it to
!> the cross-correlation problem. 
!------------------------------------------------------------------------------

module Integrand_Module
    implicit none
    
contains

    function Integrand(x, flag, param) result(return_value)
        integer, intent(in) :: flag
        real(8), intent(in) :: x, param
        real(8) :: return_value

        ! Correlation function for first model.
        if ( flag == 1 ) then
            return_value = Polarization(x) * Mass_Loss_Rate_1(x + param)
        end if

        ! Correlation function for second model.
        if ( flag == 2 ) then
            return_value = Polarization(x) * Mass_Loss_Rate_2(x + param)
        end if

        ! Mean of the correlation function.
        if ( flag == 3 ) then
            return_value = Mean_Integrand(x)
        end if

        ! Standard deviation of the correlation function.
        if ( flag == 4 ) then
            return_value = Variance_Integrand(x, param)
        end if

        ! Romberg test case. Solution to compare with is Ln(|x^3+1|)/3.
        if ( flag == 99 ) then
            return_value = x**2 / (1.0d0 + x**3 + 1.0d-99)
        end if
        
    end function Integrand

    function Polarization(x) result(return_value)
        use Load_Data_Module
        use Linear_Int_Module
        real(8), intent(in) :: x
        real(8), dimension(:), allocatable :: pol
        real(8) :: return_value

        ! Allocate the polarization array.
        allocate(pol(nmax))

        ! Calculate the absolute polarization as a fraction of the optical depth (in %).
        pol = abs(1.0d0 - 3.0d0 * gam)

        ! Calculate the value of the polarization.
        return_value = Linear_Int(x, t, pol, nmax)

        ! Deallocate the polarization array.
        deallocate(pol)

    end function Polarization

    function Mass_Loss_Rate_1(x) result(return_value)
        real(8), intent(in) :: x
        real(8) :: c_1, c_2, omega, return_value

        ! Initialize constants.
        c_1   = 3.63636363d-8
        c_2   = 9.0d0 * 3.63636363d-8
        omega = 1.864668d-7

        ! Calculate the mass-loss rate.
        return_value = c_1 + c_2 * sin(omega * x)**2

    end function Mass_Loss_Rate_1

    function Mass_Loss_Rate_2(x) result(return_value)
        real(8), intent(in) :: x
        real(8) :: c_1, c_2, c_3, omega, return_value

        ! Initialize constants.
        c_1   = 1.762712d-7
        c_2   = 1.830508d-7
        c_3   = 4.745763d-8
        omega = 3.729336d-7

        ! Calculate the mass-loss rate.
        return_value = c_1 + c_2 * sin(omega * x) + c_3 * sin(omega * x)**2

    end function Mass_Loss_Rate_2

    function Mean_Integrand(x) result(return_value)
        use Correlation_Module
        use Linear_Int_Module
        real(8), intent(in) :: x
        real(8) :: return_value

        ! Calculate the correlation function divided by the interval size.
        return_value = Linear_Int(x, tau, C, tau_max_index) / (tau(tau_max_index) - tau(1))
    
    end function Mean_Integrand

    function Variance_Integrand(x, mean_of_function) result(return_value)
        use Correlation_Module
        use Linear_Int_Module
        real(8), intent(in) :: x, mean_of_function
        real(8) :: return_value, interpolated_C_value

        ! Calculate the interpolated correlation function value.
        interpolated_C_value = Linear_Int(x, tau, C, tau_max_index)

        ! Calculate the full integrand for standard deviation.
        return_value = (interpolated_C_value - mean_of_function)**2 / (tau(tau_max_index) - tau(1))
        
    end function Variance_Integrand
    
end module Integrand_Module