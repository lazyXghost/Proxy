# Proxy setup in ubuntu

open proxy_adder, proxy_remover first and add your sudo password in PASSWORD in line 4 <br>
now add file path to proxy_setter.py in both proxy_adder and proxy_remover <br>
Now just do bash proxy_adder <br>
It will set proxy everywhere in your computer

To set terminal proxy <br>
1) export http_proxy=http://gateway.iitmandi.ac.in:8080 <br>
2) export https_proxy=http://gateway.iitmandi.ac.in:8080 <br>




# Removing proxy 
bash proxy_remover <br>
In Terminal -: <br>
1) unset http_proxy <br>
2) unset https_proxy <br>
