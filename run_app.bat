echo make sure you run this file in a terminal ending in newsapp/
cd server
cd newsapi
start /B node . & echo STARTED NEWSAPI ON http://localhost:3535/
cd..
cd summarizationapi
start /B poetry run python main.py & echo STARTED SUMMARIZATIONAPI ON http://localhost:8080/
cd..
cd..
cd webapp
cd newsapp 
start /B flutter run -d Chrome --release
echo THE SUMMARIES WILL NOT SHOW IF FLUTTER LOADS BEFORE SUMMARIZATIONAPI