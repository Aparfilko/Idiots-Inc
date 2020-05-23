cd /D "%~dp0"
g++ -shared -o bin\libgdplayer.dll src\Actors\Player.cpp -Ofast -DNDEBUG -s -I..\..\godot-cpp\godot_headers -I..\..\godot-cpp\include -I..\..\godot-cpp\include\core -I..\..\godot-cpp\include\gen -Isrc -L..\..\godot-cpp\bin -lgodot-cpp.windows.release.64
if errorlevel 1 ( pause ) else ( ..\..\Godot.exe )