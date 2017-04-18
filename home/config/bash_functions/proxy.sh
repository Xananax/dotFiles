# vi:syntax=sh
#!/usr/bin/env bash

assignProxy(){
	local full=$1
	local url=$2
	local port=$3
	export http_proxy=$1
	export https_proxy=$http_proxy
	export ftp_proxy=$http_proxy
	export rsync_proxy=$http_proxy
	export HTTP_PROXY=$http_proxy
	export HTTPS_PROXY=$http_proxy
	export FTP_PROXY=$http_proxy
	export RSYNC_PROXY=$http_proxy
	
	gsettings set org.gnome.system.proxy mode 'manual' 
	gsettings set org.gnome.system.proxy.http host '$url'
	gsettings set org.gnome.system.proxy.http port $port
	gsettings set org.gnome.system.proxy.ftp host '$url'
	gsettings set org.gnome.system.proxy.ftp port $port
	gsettings set org.gnome.system.proxy.https host 'proxy.localdomain.com'
	gsettings set org.gnome.system.proxy.https port $port
	gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '10.0.0.0/8', '192.168.0.0/16', '172.16.0.0/12' , '*.localdomain.com' ]"
	echo "Proxy environment variable set."
}

function proxyOn() {
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
    export NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"

    local url=$1
    local port=$2
    local user=$3
    local password=$4
    local pre=''

    if (( $# > 0 )); then
        valid=$(echo $1 | sed -n 's/\([0-9]\{1,3\}.\)\{4\}/&/p')
        if [[ $valid != $url ]]; then
            >&2 echo "Invalid address"
            return 1
        fi
        valid=$(echo $2 | sed -n 's/\([0-9]\+\)/&/p')
        if [[ $valid != $port ]]; then
            >&2 echo "Invalid port"
            return 1
        fi
        if [ -n "$user" ]; then
		    if [[ $user != "" ]]; then
		    	if [ -z "$password" ]; then
			        echo -n "password: "
			        read password
		    	fi
		        pre="$user:$password@"
		    fi
        fi
        url="http://$pre$url"
        local full="$url:$port/"
        assignProxy $full $url $port
        return 0
    fi

    echo 'usage: url port user [password]'
    echo 'example: proxyOn 10.203.0.1 5187'
    echo 'if you pass a username, you will be prompted for a password'
    echo 'to reset, use proxyOff'
    
}

function proxyOff(){
    unset http_proxy
    unset https_proxy
    unset ftp_proxy
    unset rsync_proxy
	unset HTTP_PROXY
	unset HTTPS_PROXY
	unset FTP_PROXY
	unset RSYNC_PROXY
	gsettings reset org.gnome.system.proxy mode
	gsettings reset org.gnome.system.proxy.http host
	gsettings reset org.gnome.system.proxy.http port
	gsettings reset org.gnome.system.proxy.ftp host
	gsettings reset org.gnome.system.proxy.ftp port
	gsettings reset org.gnome.system.proxy.https host
	gsettings reset org.gnome.system.proxy.https port
	gsettings reset org.gnome.system.proxy ignore-hosts
    echo -e "Proxy environment variable removed."
}
