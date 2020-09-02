cd /D "%~dp0"
g++ TerrainGen.cpp -o ..\bin\libgdterraingen.dll -Ofast -g0 -static-libgcc -static-libstdc++ -shared -s -DNDEBUG -I..\..\..\godot-cpp\include -I..\..\..\godot-cpp\include\core -I..\..\..\godot-cpp\include\gen -I..\..\..\godot-cpp\godot_headers -L..\..\..\godot-cpp\bin -lgodot-cpp.windows.release.64
if errorlevel 1 ( pause ) else ( cd ..\ & ..\..\Godot.exe )