To build Mesa:
1) You need clone this repository - "git clone https://github.com/serhii-nakon/new_mesa.git";
2) Configure LXC to be able run it in unprivileged mode
3) Run lxcup.sh
4) It will create folder named mesa with mesa packages

To install from release:
1) Download archive
2) Run install.sh (this version of mesa only for debian 11)

If you use two amd cards with xorg maybe you will need run it to be able use both

`echo 'xrandr --setprovideroutputsource 1 0' | sudo tee /etc/X11/Xsession.d/10custom_initialise_xrandr`
