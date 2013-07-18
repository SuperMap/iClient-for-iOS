@echo off

set NaturalDocsParams=-i ..\MapView\Map -o HTML ..\Doc -p ..\apidoc_config -s 1 -s 2
::Roman
::Small            
            
rem Shift and loop so we can get more than nine parameters.
rem This is especially important if we have spaces in file names.

:MORE
if "%1"=="" goto NOMORE
set NaturalDocsParams=%NaturalDocsParams% %1
shift
goto MORE
:NOMORE

D:\perl\bin\perl.exe NaturalDocs %NaturalDocsParams%

set NaturalDocsParams=-i ..\MapView\Map -o HTML ..\Doc -p ..\apidoc_config -s 1 -s 2

pause