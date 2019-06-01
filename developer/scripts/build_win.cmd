:: Build spacepy on windows
:: Assume win_build_system_setup.cmd has already been run
@ECHO OFF
SETLOCAL EnableDelayedExpansion

FOR %%B in (32 64) DO (FOR %%P in (2 3) DO CALL :build %%B %%P)

GOTO :EOF

:build
IF "%1"=="32" (
    set CONDA_PKGS_DIRS=%USERPROFILE%\Miniconda3\PKGS32
    set CONDA_SUBDIR=win-32
    set CONDA_FORCE_32_BIT=1
) ELSE (
    set CONDA_PKGS_DIRS=%USERPROFILE%\Miniconda3\PKGS64
    set CONDA_SUBDIR=win-64
    set CONDA_FORCE_32_BIT=
)
IF "%2"=="2" (
    set PYVER=27
) ELSE (
    set PYVER=36
)
CALL %USERPROFILE%\Miniconda3\Scripts\activate py%2_%1
pushd %~dp0\..\..\
CALL python setup.py bdist_wininst --fcompiler=gnu95
for %%f in (dist\spacepy-*.*.*.win32.exe dist\spacepy-*.*.*.win-amd64.exe) DO (
    set OLDNAME=%%f
    :: Strip off the dist/ on the target...
    rename !OLDNAME! !OLDNAME:~5,-4!.py%PYVER%.exe
)
popd
::This turns off echo!
CALL conda deactivate
GOTO :EOF
