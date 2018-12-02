ECHO OFF
color 0b
CLS
title ARMA Menu

:MENU
cls
ECHO.
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO  1 - DayZ generate shaders
ECHO  2 - DayZ Server
ECHO  3 - Save System
ECHO  4 - DayZ Client
ECHO  5 - Kill DayZ
ECHO  6 - Buldozer
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO Blank entry to exit.
ECHO.

SET /P M=#

IF %M%==1 GOTO generateshaders
IF %M%==2 GOTO Static
IF %M%==3 GOTO Save
IF %M%==4 GOTO Client
IF %M%==5 GOTO Kill
IF %M%==6 GOTO buldozer

:generateshaders
start DayZLegacy.exe -generateshaders
GOTO MENU

:Static
start DayZServer.exe -port=2302 -config=config\server.cfg -profiles=dayzea.ChernarusPlus -cfg=config\basic.cfg -name=Server
GOTO MENU

:Save
start /d "bss3" UwAmp.exe  -profiles=dayzea.ChernarusPlus
GOTO MENU

:Client
start DayZLegacy.exe -cfg=config\basic.cfg -profiles=dayzea.ChernarusPlus
GOTO MENU

:Kill
taskkill /f /im DayZServer.exe
taskkill /f /im DayZLegacy.exe
GOTO MENU

:buldozer
start DayZLegacy.exe -buldozer -cfg=config\basic.cfg -world=ChernarusPlus -profiles=dayzea.ChernarusPlus
GOTO MENU