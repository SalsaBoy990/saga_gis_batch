REM @ECHO OFF

REM ********************************************************************
REM Create mean and median images and clip them with polygons
REM Author: Andras Gulacsi
REM E-mail: admin@newgeographer.com
REM Date: September 10th, 2017
REM Post title: SAGA GIS: Földrajzi adatfeldolgozás a parancssorban
REM Post link ********************************************************************


REM *************** PATHS ******************

REM Path to saga_cmd.exe
set PATH=%PATH%;g:\saga-5.0.0_x64\

REM Path to working dir
SET WORK=g:\modis_feri\2016\EOV_2016\ndvi\
SET RESULT=g:\modis_feri\TEMP
SET SHAPES=g:\modis_feri\
SET POLYGON=00_l_250_66sz_poli.shp
SET POSTFIX=_00_l
SET YEAR=2016


REM ****************************************


FOR /F %%i IN ('dir /b %WORK%\*.tif') DO (


REM Tool: Import Raster

saga_cmd io_gdal 0 ^
-GRIDS=%WORK%\%%i.sgrd ^
-FILES=%WORK%\%%i ^
-TRANSFORM=0

)


REM Tool: Statistics for Grids

saga_cmd statistics_grid 4 ^
-GRIDS=%WORK%\NDVI2016081_eov_kiv.tif.sgrd;%WORK%\NDVI2016097_eov_kiv.tif.sgrd;%WORK%\NDVI2016113_eov_kiv.tif.sgrd;%WORK%\NDVI2016129_eov_kiv.tif.sgrd;%WORK%\NDVI2016145_eov_kiv.tif.sgrd;%WORK%\NDVI2016161_eov_kiv.tif.sgrd;%WORK%\NDVI2016177_eov_kiv.tif.sgrd;%WORK%\NDVI2016193_eov_kiv.tif.sgrd;%WORK%\NDVI2016209_eov_kiv.tif.sgrd;%WORK%\NDVI2016225_eov_kiv.tif.sgrd;%WORK%\NDVI2016241_eov_kiv.tif.sgrd;%WORK%\NDVI2016257_eov_kiv.tif.sgrd;%WORK%\NDVI2016273_eov_kiv.tif.sgrd ^
-MEAN=%RESULT%\atlag.sgrd ^
-PCTL=%RESULT%\median.sgrd ^
-PCTL_VAL=50


REM Tool: Clip Grid with Polygon

saga_cmd shapes_grid 7 ^
-INPUT=%RESULT%\atlag.sgrd ^
-OUTPUT=%RESULT%\atlag%POSTFIX%.sgrd ^
-POLYGONS=%SHAPES%\%POLYGON% ^
-EXTENT=0

saga_cmd shapes_grid 7 ^
-INPUT=%RESULT%\median.sgrd ^
-OUTPUT=%RESULT%\median%POSTFIX%.sgrd ^
-POLYGONS=%SHAPES%\%POLYGON% ^
-EXTENT=0


REM Tool: Export GeoTIFF

saga_cmd io_gdal 2 ^
-GRIDS=%RESULT%\atlag%POSTFIX%.sgrd ^
-FILE=%RESULT%\%YEAR%_atlag%POSTFIX%.tif

saga_cmd io_gdal 2 ^
-GRIDS=%RESULT%\median%POSTFIX%.sgrd ^
-FILE=%RESULT%\%YEAR%_median%POSTFIX%.tif


PAUSE