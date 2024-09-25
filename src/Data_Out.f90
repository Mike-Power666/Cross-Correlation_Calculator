!------------------------------------------------------------------------------
! Memorial University of Newfoundland, MSc Student
!------------------------------------------------------------------------------
!
! MODULE: Data_Output
!
!> @Mike-Power666
!> Michael Power
!
! DESCRIPTION: 
!> This module opens a file and dumps the data into arrays, while avoiding
!> "gotchas".
!
! REVISION HISTORY:
! 28/06/2024 - Initial Version
!------------------------------------------------------------------------------

module Data_Output_Module
    implicit none
contains

    subroutine Data_Output(tau, C, filename)
        real(8), dimension(:), intent(in) :: tau, C
        character(len=*), intent(in) :: filename
        integer :: i, unit_num, num_lines
        logical :: logic_dummy

        ! Determine a unit number for the file.
        do unit_num = 10, 99
            inquire(unit=unit_num, opened=logic_dummy)
            if (.not. logic_dummy) exit ! Exit the loop if the unit number is not in use.

            ! Idiot proofing if too many files are opened.
            if (unit_num == 99) then
                print *, "Too many files opened. Data_Output failed."
                stop
            end if
        end do

        ! Open the file.
        open(newunit=unit_num, file=filename, status='replace', action='write', iostat=i)
        ! Idiot proofing.
        if (i /= 0) then
            print *, "Error opening file: ", trim(filename)
            stop
        end if

        ! Write data to the file.
        num_lines = size(tau)
        
        do i = 1, num_lines
            print *, tau(i), C(i)
        end do

        do i = 1, num_lines
            write(unit_num, '(2e25.15)') tau(i), C(i)
        end do

        ! Close the file.
        close(unit_num)

        print *, "Data successfully written to file: ", trim(filename)
    end subroutine Data_Output

end module Data_Output_Module