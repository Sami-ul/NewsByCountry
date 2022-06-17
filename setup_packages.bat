echo make sure you run this file in a terminal ending in newsapp/
cd server
cd newsapi
start /B npm install
echo initializing newsapi packages
cd..
cd summarizationapi
start /B poetry install
echo initializing summarizationapi packages
cd..
cd..
cd webapp
cd newsapp 
start /B flutter pub get
echo initializing flutter packages
echo completed initialization