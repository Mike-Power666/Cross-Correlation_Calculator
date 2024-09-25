!------------------------------------------------------------------------------
! Saint Mary's University, Honours Student
!------------------------------------------------------------------------------
!
! MODULE: Binary_Search
!
!> @Mike-Power666
!> Michael Power
!
! DESCRIPTION: 
!> A classic, simple, and efficient binary search algorithm. The array being
!> searched bust be monotonic and increasing. This algorithm returns the index
!> of the first entry greater than or equal to the value passed.
!
! REVISION HISTORY:
! 30/04/2017 - Initial Version
! 26/06/2024 - Revision 1
!> Refactored the original algorithm to be more modular.
!------------------------------------------------------------------------------

module Binary_Search_Module
    implicit none
    
contains
    subroutine Binary_Search(monotonic_array, num_elements, value, index)
        implicit none
        integer, intent(in) :: num_elements
        real(8), dimension(num_elements), intent(in) :: monotonic_array
        real(8), intent(in) :: value
        integer, intent(out) :: index
        integer :: low, high, mid
        
        ! Initialize indices.
        low = 1
        high = num_elements
        
        ! Binary search.
        do while (low < high)
            mid = (low + high) / 2
            if (monotonic_array(mid) < value) then
                low = mid + 1
            else
                high = mid
            end if
        end do
        
        ! Check if the element has been found.
        if (monotonic_array(low) >= value) then
            index = low
        else
            print *, 'Binary search failed... Is your array monotonically increasing?'
        end if
        
    end subroutine Binary_Search

end module Binary_Search_Module