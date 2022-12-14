C $Header: /u/gcmpack/MITgcm_contrib/dfer/cpl_aim+ocn_fast/code_cpl/OCNSIZE.h,v 1.1 2006/07/06 18:14:42 dfer Exp $
C $Name:  $

C     /==========================================================\
C     | OCN_SIZE.h Declare size of underlying computational grid |
C     |            for ocean component.                          |
C     \==========================================================/
C     Nx_ocn  - No. points in X for the total domain.
C     Ny_ocn  - No. points in Y for the total domain.
      INTEGER Nx_ocn
      INTEGER Ny_ocn
      PARAMETER (
     &           Nx_ocn  = 144,
     &           Ny_ocn  =  24)
