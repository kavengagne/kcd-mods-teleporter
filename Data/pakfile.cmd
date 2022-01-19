REM This script packages the mod files

del Data.pak
7z a Data.zip . -x!*.cmd -x!*.bat -x!.git
move Data.zip Data.pak
