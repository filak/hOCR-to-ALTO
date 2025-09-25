@echo off
setlocal
REM Exit on error
setlocal enabledelayedexpansion

REM Validate inputs
set INPUT=%1
set XSL=%2
set OUTPUT=%3

if "%INPUT%"=="" (
  echo Usage: run-saxon input.xml stylesheet.xsl output.xml
  exit /b 1
)
if "%XSL%"=="" (
  echo Usage: run-saxon input.xml stylesheet.xsl output.xml
  exit /b 1
)
if "%OUTPUT%"=="" (
  echo Usage: run-saxon input.xml stylesheet.xsl output.xml
  exit /b 1
)

REM Paths
set SCRIPT_DIR=%~dp0
set SAXON_DIR=%SCRIPT_DIR%saxon
set INPUT_FILE=%SCRIPT_DIR%_input\%INPUT%
set XSL_FILE=%SCRIPT_DIR%%XSL%
set OUTPUT_DIR=%SCRIPT_DIR%_output
set OUTPUT_FILE=%OUTPUT_DIR%\%OUTPUT%

REM Ensure _output folder exists
if not exist "%OUTPUT_DIR%" (
  mkdir "%OUTPUT_DIR%"
)

REM Use provided SAXON_JAR or default
if not defined SAXON_JAR (
  set SAXON_JAR=%SAXON_DIR%\saxon-he-12.9.jar
)

REM Verify that the JAR file exists
if not exist "%SAXON_JAR%" (
  echo Error: Saxon JAR not found at "%SAXON_JAR%"
  exit /b 1
)

REM Run Saxon
java -jar "%SAXON_JAR%" -s:"%INPUT_FILE%" -xsl:"%XSL_FILE%" -o:"%OUTPUT_FILE%"

endlocal
