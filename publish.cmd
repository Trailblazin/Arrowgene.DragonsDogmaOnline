@echo off
setlocal enabledelayedexpansion
REM https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-publish?tabs=netcore2x
SET /p VERSION=<ddon.version
SET RUNTIMES=win-x64
SET ZIP="C:\Program Files\7-Zip\7z.exe"
mkdir .\release

(for %%x in (%RUNTIMES%) do (
    REM Clean Previous Publish Files
    if exist .\publish\%%x-%VERSION%\ RMDIR /S /Q .\publish\%%x-%VERSION%\
    REM Clean Previous Release Packages
    if exist .\release\%%x-%VERSION%.tar.gz del .\release\%%x-%VERSION%.tar.gz\

    REM Build Game Server
    dotnet build Arrowgene.Ddon.Cli\Arrowgene.Ddon.Cli.csproj  --configuration Release

    if %ERRORLEVEL% EQU 0 (
    echo Build Successful for: %%x

    REM Publish runtime files
    dotnet publish Arrowgene.Ddon.Cli\Arrowgene.Ddon.Cli.csproj /p:Version=%VERSION% --runtime %%x --self-contained --output ./publish/%%x-%VERSION%/Server

    REM Copy Release Files for Publish
    xcopy .\ReleaseFiles .\publish\%%x-%VERSION%\

    REM Package publish files for release
    if exist %ZIP% %ZIP% -ttar a dummy .\publish\%%x-%VERSION%\* -so | %ZIP% -si -tgzip a .\release\%%x-%VERSION%.tar.gz
    echo Publishing runtime files for %%x... done!  
    ) else (
    echo Build failed for runtime: %%x; publishing skipped.
    )
))
REM keep console open
cmd