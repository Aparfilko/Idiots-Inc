cd /D "%~dp0"
g++ main.cpp -o bin\libgdmain.dll -Ofast -g0 -shared -s -DNDEBUG -I..\..\..\godot-cpp\include -I..\..\..\godot-cpp\include\core -I..\..\..\godot-cpp\include\gen -I..\..\..\godot-cpp\godot_headers -L..\..\..\godot-cpp\bin -lgodot-cpp.windows.release.64
if errorlevel 1 ( pause ) else ( ..\..\..\Godot.exe )