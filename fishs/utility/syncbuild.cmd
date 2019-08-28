@echo off
SET Branch=%~1
SET Baselinebuild=%~2
SET Currentbuild=%~3
SET Layer=%~4

::-----------------------------------------------------------------------------
::Prepares the Enlistment VHD for use on end users machine
::-----------------------------------------------------------------------------
::  Will now use an environment variable that is present on the machine
SET VHDLETTER="H:"
RD /s /q H:\%Branch%-%Baselinebuild%-%Currentbuild%
MKDIR H:\%Branch%-%Baselinebuild%-%Currentbuild%\baseline
MKDIR H:\%Branch%-%Baselinebuild%-%Currentbuild%\now

echo Branch %Branch% bettween %Baselinebuild% and %Currentbuild%
::-------------------------------------
::Do SD Sync to bring enlistment up to date
::-------------------------------------
SET SYP="Source\Application\Foundation\SYP"
SET Kernel="Source\Kernel"
SET Frameworks="Source\Frameworks"
echo %Layer%
if "%Layer%"=="SYP" (
echo BEGIN SD SYNC baseline build %Baselinebuild% in %SYP%
pushd %VHDLETTER%\%Branch%\%SYP% && \\dyn\ax\tools\enlistme\sd sync ...@%Baselinebuild%>H:\%Branch%-%Baselinebuild%-%Currentbuild%\baseline\syp.txt && popd
echo END SD SYNC baseline build %Baselinebuild%

echo BEGIN SD SYNC current build %Currentbuild% in %SYP%
pushd %VHDLETTER%\%Branch%\%SYP% && \\dyn\ax\tools\enlistme\sd sync ...@%Currentbuild% > H:\%Branch%-%Baselinebuild%-%Currentbuild%\now\%Branch%-%Baselinebuild%-%Currentbuild%-SYP.txt && popd
echo END SD SYNC current build %Currentbuild%
)

if "%Layer%"=="Kernel" (
echo BEGIN SD SYNC baseline build %Baselinebuild% in %Kernel%
pushd %VHDLETTER%\%Branch%\%Kernel% && \\dyn\ax\tools\enlistme\sd sync ...@%Baselinebuild%>H:\%Branch%-%Baselinebuild%-%Currentbuild%\baseline\kernel.txt && popd
echo END SD SYNC baseline build %Baselinebuild%

echo BEGIN SD SYNC current build %Currentbuild% in %Kernel%
pushd %VHDLETTER%\%Branch%\%Kernel% && \\dyn\ax\tools\enlistme\sd sync ...@%Currentbuild% >H:\%Branch%-%Baselinebuild%-%Currentbuild%\now\%Branch%-%Baselinebuild%-%Currentbuild%-Kernel.txt && popd
echo END SD SYNC current build %Currentbuild%
)

if "%Layer%"=="Frameworks" (
echo BEGIN SD SYNC baseline build %Baselinebuild% in %Frameworks%
pushd %VHDLETTER%\%Branch%\%Frameworks% && \\dyn\ax\tools\enlistme\sd sync ...@%Baselinebuild% >H:\%Branch%-%Baselinebuild%-%Currentbuild%\baseline\frameworks.txt && popd
echo END SD SYNC baseline build %Baselinebuild%

echo BEGIN SD SYNC current build %Currentbuild% in %Frameworks%
pushd %VHDLETTER%\%Branch%\%Frameworks% && \\dyn\ax\tools\enlistme\sd sync ...@%Currentbuild% >H:\%Branch%-%Baselinebuild%-%Currentbuild%\now\%Branch%-%Baselinebuild%-%Currentbuild%-Frameworks.txt && popd
echo END SD SYNC current build %Currentbuild%
)