!------------------------------------------------------------------------------
! Saint Mary's University, Honours Student
!------------------------------------------------------------------------------
!
! MODULE: Linear_Int
!
!> @Mike-Power666
!> Michael Power
!
! DESCRIPTION: 
!> A simple linear interpolator for an array of function values, y. Note that
!> the array of associated variable values must be monotonically increasing
!> for the binary search algorithm to function properly. 
!
! REVISION HISTORY:
! 30/04/2017 - Initial Version
! 26/06/2024 - Revision 1
!> Refactored the original algorithm to be more modular.
!------------------------------------------------------------------------------

module Linear_Int_Module
    use Binary_Search_Module
    implicit none
    
contains

    function Linear_Int(int_value, x, y, num_elements) result(return_value)
        integer, intent(in) :: num_elements
        real(8), dimension(num_elements), intent(in) :: x, y 
        real(8), intent(in) :: int_value
        integer :: index
        real(8) :: x_1, y_1, x_2, y_2, return_value

        ! Call binary search.
        call Binary_Search(x, num_elements, int_value, index)

        ! If the binary search returned the max or min value for the array, return the 
        ! lest there be a segfault corresponding value.
        if ( index == num_elements ) then
            return_value = y(num_elements)
        elseif ( index == 1 ) then
            return_value = y(1)
        else
            ! Set the values from the binary search for the linear interpolation.
            x_1 = x(index - 1)
            y_1 = y(index - 1)
            x_2 = x(index)
            y_2 = y(index)

            ! Compute the linear interpolation.
            return_value = (y_2 - y_1) * (int_value - x_1) / (x_2 - x_1) + y_1
        end if
        
    end function Linear_Int
    
end module Linear_Int_Module