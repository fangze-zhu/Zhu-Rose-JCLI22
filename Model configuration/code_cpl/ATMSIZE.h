C $Header: /u/gcmpack/MITgcm_contrib/dfer/cpl_aim+ocn_fast/code_cpl/ATMSIZE.h,v 1.1 2006/07/06 18:14:42 dfer Exp $
C $Name:  $

C     /==========================================================\
C     | ATMSIZE.h  Declare size of underlying computational grid |
C     |            for atmosphere component.                     |
C     \==========================================================/
C     Nx_atm  - No. points in X for the total domain.
C     Ny_atm  - No. points in Y for the total domain.
      INTEGER Nx_atm
      INTEGER Ny_atm
      PARAMETER (
     &           Nx_atm  = 144,
     &           Ny_atm  =  24)
