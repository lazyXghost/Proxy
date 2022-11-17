#! usr/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
env="${SCRIPT_DIR}/.env"
if [ -f $env ]
then
    export $(grep -v '^#' $env | xargs)
else
    echo ".env file does not exists"
fi

get_network_ssid_without_spaces() {
    ssid=$(iwgetid)
    ssid=${ssid#*'"'}
    ssid=${ssid%'"'*}
    ssid=$(echo $ssid | sed 's/ //g')
    echo $ssid
}

set_gsettings() {
    # gsettings list-recursively org.gnome.system.proxy
    gsettings set org.gnome.system.proxy mode $1
    gsettings set org.gnome.system.proxy.ftp host $2
    gsettings set org.gnome.system.proxy.ftp port $3
    gsettings set org.gnome.system.proxy.http host $2
    gsettings set org.gnome.system.proxy.http port $3
    gsettings set org.gnome.system.proxy.https host $2
    gsettings set org.gnome.system.proxy.https port $3
    gsettings set org.gnome.system.proxy.socks host $2
    gsettings set org.gnome.system.proxy.socks port $3
}

wait_for_window_opening() {
    while true;
    do
    	active_window=($(xdotool search --name "IIT Mandi"))
    	if [ "${active_window[0]}" == "" ];
    	then
	    sleep 0.2
    	else
    	    break
    	fi
    done
}

activate_gateway_window() {
    windowid=($(xdotool search --name "IIT Mandi"))
    xdotool windowactivate ${windowid[0]}
}

close_all_active_gateway_windows() {
    while true;
    do
    	active_window=($(xdotool search --name "IIT Mandi"))
    	if [ "${active_window[0]}" == "" ];
    	then
    	    break
    	else
	    activate_gateway_window
	    xdotool key ctrl+w
    	fi
    	sleep 0.2
    done
}


gateway_login() {
    $browser_name --new-window https://stgw.iitmandi.ac.in
    wait_for_window_opening
    for i in {1..5}
    do
        sleep 0.1
        activate_gateway_window
        xdotool key Tab
    done
    activate_gateway_window
    xdotool type $gateway_username
    sleep 0.2
    activate_gateway_window
    xdotool key Tab
    sleep 0.2
    activate_gateway_window
    xdotool type $gateway_password
    sleep 0.2
    activate_gateway_window
    xdotool key Tab
    sleep 0.2
    activate_gateway_window
    xdotool key Return
    sleep 0.3
    activate_gateway_window
    xdotool key ctrl+w
}

ssid=$( get_network_ssid_without_spaces )
if [ $ssid == $proxy_ssid1  ] | [ $ssid == $proxy_ssid2 ];
then 
    set_gsettings "manual" "$proxy" "$port"
    close_all_active_gateway_windows
    gateway_login
else
    set_gsettings "none" "''" "0"
fi

echo $sudo_password | sudo -S "${SCRIPT_DIR}/script.py"
