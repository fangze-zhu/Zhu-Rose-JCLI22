C $Header: /u/gcmpack/MITgcm/pkg/dic/DIC_OPTIONS.h,v 1.6 2008/04/07 20:31:16 dfer Exp $
C $Name:  $

#ifndef DIC_OPTIONS_H
#define DIC_OPTIONS_H
#include "PACKAGES_CONFIG.h"
#ifdef ALLOW_DIC

#include "CPP_OPTIONS.h"

#define DIC_BIOTIC
#undef  ALLOW_FE
#define ALLOW_O2
#undef READ_PAR
#undef MINFE
#define DIC_NO_NEG
c these all need to be defined for coupling to
c atmospheric model
#define USE_QSW
#define USE_QSW_UNDERICE
#define USE_ATMOSCO2
#define USE_PLOAD

#undef ALLOW_OLD_VIRTUALFLUX

#endif /* ALLOW_DIC */
#endif /* DIC_OPTIONS_H */

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
