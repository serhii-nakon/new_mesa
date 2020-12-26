To use this Mesa:
1) You need clone this repository - "git clone https://github.com/serhii-nakon/new_mesa.git";
2) Copy folder "amdgpu-mesa" to "/opt/" - "sudo cp -r new_mesa/amdgpu-mesa /opt";
3) Copy from folder "/opt/amdgpu-mesa/" this two files "mesa32.list" and "mesa64.list" to "/etc/apt/sources.list.d/" - "sudo cp /opt/amdgpu-mesa/*.list /etc/apt/sources.list.d";
4) Run "sudo apt update";
5) Run "sudo apt full-upgrade"
