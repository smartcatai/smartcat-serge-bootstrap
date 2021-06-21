@echo off

set PARAMS="--entrypoint /usr/local/bin/boot/run-in-docker.sh"
if "%~1"=="" (
    echo "No arguments provided, will run an interactive shell"
    echo Mounting %~dp0 as /root
    set PARAMS="-it --entrypoint /usr/local/bin/boot/serge-shell.sh"
)

docker run ^
    --rm ^
    -v "%~dp0:/root" ^
    %PARAMS% ^
    --env PS1="\[\033[01;35m\][Serge Shell]\[\033[00m\] \w \$ " ^
    smartcatcom/serge:v2
    %*
