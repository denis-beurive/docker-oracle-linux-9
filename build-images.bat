echo off
set "PWD=%~dp0"

cd %PWD%
docker build --tag oracle-linux-9 --progress=plain .


