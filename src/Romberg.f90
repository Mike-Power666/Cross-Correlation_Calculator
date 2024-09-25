!------------------------------------------------------------------------------
! Saint Mary's University, Honours Student
!------------------------------------------------------------------------------
!
! MODULE: Romberg
!
!> @Mike-Power666
!> Michael Power
!
! DESCRIPTION: 
!> A Romberg numerical integrator. This program will output the numerical value
!> of the definite integral of your function.
!
! REVISION HISTORY:
! 29/04/2017 - Initial Version
! 14/05/2018 - Revision 1
!> Expunged all goto statements from the original FORTRAN77 version of this 
!> algorithm and replaced them with while loops and more clear exit conditions.
! 26/06/2024 - Revision 2
!> Refactored the original algorithm to be more modular and specialized it to
!> the cross-correlation problem. Also, an interesting bug was found when the 
!> array, T, was passed into EM in modern fortran. See the EM subroutine for
!> a more extensive comment.
!------------------------------------------------------------------------------

module Romberg_Module
    use Integrand_Module
    implicit none
  
  contains
  
    subroutine Romberg(A, B, MaxError, flag, param, Result)
        integer, intent(in) :: flag
        real(8), intent(in) :: A, B, MaxError, param
        real(8), intent(out) :: Result
        real(8), dimension(:,:), allocatable :: T
        real(8) :: R, RError, H
        integer :: Q, j, k, m
  
        ! Initialize constants and arrays.
        Q = 250
        allocate(T(Q, 0:Q))
  
        ! Compute the first E.M. sum.
        H = (B - A) / 2.0d0
        T(1, 0) = H * (Integrand(A, flag, param) + Integrand(B, flag, param)) / 2.0d0 + H * Integrand(A + H, flag, param)
  
        ! Initialize the setp m to one and call the E.M. subroutine to compute T(2,0).
        m = 1
        call EM(m, T, A, B, flag, param)
  
        ! Top of Romberg Ratio Loop
        do while (.true.)
            ! Increment the step m by one and then call the E.M. subroutine to compute T(m+1,0).
            m = m + 1
            call EM(m, T, A, B, flag, param)
  
            R = abs((T(m-1, 0) - T(m, 0)) / (T(m, 0) - T(m+1, 0) + 1.0d-99))
  
            ! If the Romberg ratio is greater than three, we've found the optimal m value to continue with.
            ! Otherwise, back to the top of the loop to iterate once again.
            if (R > 3.0d0) exit
  
            ! Warn the user if we iterate too much...
            if (m > 20) then
                print *, 'Cannot converge quickly enough... Change variables?'
                exit
            end if
        end do
        ! Bottom of Romberg Ratio Loop
  
        ! Initialize the step k to zero.
        k = 0
  
        ! Top of Richardson Extrapolation Loop
        do while (.true.)
            ! Increment the step by one.
            k = k + 1

            ! Warn the user if Richardson extrapolation fails.
            if ( (m+k) > Q ) then
                print *, 'Richardson extrapolation has failed... Increase Q?'
                exit
            end if
  
            ! Create the Richardson extrapolation table.
            do j = 1, k
                T(m+k, j) = ((4.0d0**j) * T(m+k, j-1) - T(m+k-1, j-1)) / ((4.0d0**j) - 1.0d0)
            end do
  
            ! Evaluate the Richardson error term.
            RError = 2.0d0 * abs((T(m+k, k) - T(m+k, k-1)) / (T(m+k, k) + T(m+1, k-1)))
  
            ! If the Richardson error term is less than the maximum tolerated error, we're done!
            ! Otherwise, call the E.M. subroutine to compute T(m+k+1, 0) and then back to the top of the loop!
            if (RError < MaxError) exit
  
            call EM(m+k, T, A, B, flag, param)
        end do
  
        ! Bottom of Richardson Extrapolation Loop
        Result = T(m+k, k)
  
        deallocate(T)
  
    end subroutine Romberg
  
    subroutine EM(m, T, A, B, flag, param)
      integer, intent(in) :: m, flag
      real(8), intent(in) :: A, B, param
      real(8), dimension(:,:), allocatable, intent(inout) :: T
      ! Note that since T(:,:) has non-standard indexing, one must be very cautious. If it isn't defined
      ! as an allocatable array, or passed as a pointer, the array indexing will default to normal within 
      ! the subroutine and then back to non-standard outside of the subroutine, which gets very confusing.
      ! This was a result of technical changes to 'allocatable' on dummy arguments in 1997. This comment 
      ! serves as a reminder of this niche problem for the future. 
      real(8) :: Sum, H
      integer :: i
  
      ! Calculate the E.M. sum for the (m+1)th step.
      Sum = 0.0d0
      H = (B - A) / (2.0d0**(m+1))
  
      do i = 1, (2**(m+1)-1), 2
         Sum = Integrand(A + real(i, kind=8) * H, flag, param) + Sum
      end do
      
      T(m+1, 0) = T(m, 0) / 2.0d0 + H * Sum
  
    end subroutine EM
  
  end module Romberg_Module  