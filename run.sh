echo -e "\t--- RUNNING CHECKS ---"
./check.sh
echo -e "\n\t--- GENERATING LUA CODE ---"
./gen.sh
echo -e "\n\t--- RUNNING GAME ---"
love .
echo -e "\n\t--- CLEANING UP ---"
./clean.sh