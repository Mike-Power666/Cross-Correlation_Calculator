!------------------------------------------------------------------------------
! Memorial University of Newfoundland, MSc Student
!------------------------------------------------------------------------------
!
! MODULE: Load_Data
!
!> @Mike-Power666
!> Michael Power
!
! DESCRIPTION: 
!> This module opens a file and loads the data into arrays, while avoiding
!> "gotchas".
!
! REVISION HISTORY:
! 25/06/2024 - Initial Version
!------------------------------------------------------------------------------

module Load_Data_Module
    implicit none
    real(8), dimension(:), allocatable :: t, gam
    integer :: nmax
contains

    subroutine Load_Data(filename)
        character(len=*), intent(in) :: filename
        integer :: i, unit_num, num_lines
        character(len=100) :: line ! This should be adjusted for dynamical allocation.
        logical :: logic_dummy

        ! Determine a unit number for the file. 
        do unit_num = 10, 99
            inquire(unit=unit_num, opened=logic_dummy)
            if (logic_dummy .eqv. .false.) exit ! Exit the loop if the unit number was not in use.

            ! Idiot proofing if too many files are opened.
            if ( unit_num .eq. 99 ) then
                print *, "Too many files opened. Load_Data failed."
                stop
            end if
        end do

        ! Open the file.
        open(newunit=unit_num, file=filename, status='old', action='read', iostat=i)
        ! Idiot proofing.
        if (i /= 0) then
            print *, "Error opening file: ", trim(filename)
            stop
        end if

        ! Determine number of lines in the file for array allocation.
        num_lines = 0
        do
            read(unit_num, '(A)', iostat=i) line
            if (i /= 0) exit ! Exit loop at end of file or error.
            num_lines = num_lines + 1
        end do

        ! Allocate memory for arrays.
        allocate(t(num_lines), gam(num_lines))

        ! Rewind the file to read data.
        rewind(unit_num)

        ! Read data from the file into allocated arrays.
        do i = 1, num_lines
            read(unit_num, *) t(i), gam(i)
        end do

        ! Close the file.
        close(unit_num)

        ! Set nmax to the number of lines read.
        nmax = num_lines

        print *, "Data loaded successfully from file: ", trim(filename)
    end subroutine Load_Data

end module Load_Data_Module