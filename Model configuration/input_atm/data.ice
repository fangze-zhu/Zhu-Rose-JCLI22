 &THSICE_CONST
 Tf0kel  = 273.15,
 rhosw   = 1030.,
#- with LANL albedo:
#albWarmSnow=0.75,
#- for full ice-fraction :
#icemaskmin = 1.,
#himin0     = 0.01,
#frac_energy= 0.,
#hihig      =100.,
#- with fractional ice:
 iceMaskmin = 0.01,
 hThinIce   = 0.1,
 hiMax      =500.,
 hsMax      = 10.,
 albIceMax  =0.60,
 albIceMin  =0.25,
 hAlbSnow   =0.05,
 hAlbIce    =0.25,
 albColdSnow=0.80,
 albWarmSnow=0.45,
 albOldSnow =0.45,
 tempSnowAlb=-5.0,
 hNewIceMax = 2.5,
 &

 &THSICE_PARM01
 thSIce_diffK=1000.,
 thSIceAdvScheme=1,
# startIceModel=1,
#stepFwd_oceMxL=.TRUE.,
 ocean_deltaT=3600.,
#tauRelax_MxL=5184000.,
 stressReduction=0.,
#thSIce_taveFreq=2592000.,
 thSIce_diagFreq=0.,
 thSIce_monFreq=2592000.,
# thSIceFract_InitFile='Drake.c32.I.IceFrc.ini.bin' ,
# thSIceThick_InitFile='Drake.c32.I.IceHgt.ini.bin' ,
# thSIceSnowH_InitFile='Drake.c32.I.SnowHgt.ini.bin',
# thSIceSnowA_InitFile='Drake.c32.I.SnowAge.ini.bin',
# thSIceEnthp_InitFile='Drake.c32.I.IceEnth.ini.bin',
# thSIceTsurf_InitFile='Drake.c32.I.IceTsrf.ini.bin',
 &
