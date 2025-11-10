echo off

set USER=dev
echo "Password=1ab2c3d4e5"
echo
echo "If it does not work:"
echo
echo "docker run --rm -it --entrypoint bash oracle-linux-9"
echo
ssh -o StrictHostKeyChecking=no ^
    -o UserKnownHostsFile=NUL ^
    -o GlobalKnownHostsFile=NUL ^
    -p 2222 %USER%@localhost
