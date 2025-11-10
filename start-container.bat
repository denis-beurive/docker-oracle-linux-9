echo off

docker run --detach ^
           --interactive ^
           --tty ^
           --rm ^
           --publish 2222:22/tcp ^
           oracle-linux-9

docker container ls --all

