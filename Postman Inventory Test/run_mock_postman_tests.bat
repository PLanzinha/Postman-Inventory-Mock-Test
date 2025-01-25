@echo off
setlocal

set COLLECTION_FILE=collections\Postman_Inventory_Test.postman_collection.json
set ENVIRONMENT_FILE=environments\Mock_Env.postman_environment.json
set REPORT_DIR=reports
set REPORT_FILE=%REPORT_DIR%\Postman_Inventory_Mock_Test.html

if not exist "%REPORT_DIR%" mkdir "%REPORT_DIR%"

echo ==========================================================
echo Starting Product Inventory Mock Server Tests via Newman
echo ==========================================================

newman run "%COLLECTION_FILE%" ^
    -e "%ENVIRONMENT_FILE%" ^
    -r cli,htmlextra --reporter-htmlextra-export "%REPORT_FILE%" ^
    --disable-unicode

set NEWMAN_EXIT_CODE=%ERRORLEVEL%

echo ==========================================================
if %NEWMAN_EXIT_CODE% == 0 (
  echo Newman Mock Server tests PASSED successfully!
  echo Report available at: %REPORT_FILE%
) else (
  echo Newman Mock Server tests FAILED! Exit code: %NEWMAN_EXIT_CODE%
  echo Check the console output and the report (if generated) at: %REPORT_FILE%
)
echo ==========================================================

exit /b %NEWMAN_EXIT_CODE%
endlocal