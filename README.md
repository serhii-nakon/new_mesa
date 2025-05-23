Description:</br>
Here simple build newest Mesa with last LLVM (yes, it contain already prebuilt newer LLVM from official LLVM APT repo) and new DRM for current Debian.

To build Mesa:
1) You need clone this repository - "git clone https://github.com/serhii-nakon/new_mesa.git";
2) Run `docker compose build --no-cache`
3) Run `docker compose up`
4) Install Mesa 32 bit `sudo cp -vr mesa32/ /opt/`
5) Install Mesa 64 bit `sudo cp -vr mesa64/ /opt/`
6) Set environment variables into `/etc/environment`</br>
```
LD_LIBRARY_PATH="/opt/mesa64/lib/x86_64-linux-gnu:/opt/mesa32/lib/i386-linux-gnu:/opt/mesa64/lib/x86_64-linux-gnu/vdpau:/opt/mesa32/lib/i386-linux-gnu/vdpau"
LIBGL_DRIVERS_PATH="/opt/mesa64/lib/x86_64-linux-gnu/dri:/opt/mesa32/lib/i386-linux-gnu/dri"
VK_LAYER_PATH="/opt/mesa64/share/vulkan/explicit_layer.d:/opt/mesa32/share/vulkan/explicit_layer.d:/usr/share/vulkan/explicit_layer.d"
VK_ICD_FILENAMES="/opt/mesa64/share/vulkan/icd.d/radeon_icd.x86_64.json:/opt/mesa32/share/vulkan/icd.d/radeon_icd.i686.json:/opt/mesa64/share/vulkan/icd.d/lvp_icd.x86_64.json:/opt/mesa32/share/vulkan/icd.d/lvp_icd.i686.json"
LIBVA_DRIVERS_PATH="/opt/mesa64/lib/x86_64-linux-gnu/dri:/opt/mesa32/lib/i386-linux-gnu/dri"
#VK_INSTANCE_LAYERS=VK_LAYER_MESA_overlay
```

To install from release:
1) Download archive
2) Extract files (it should contain mesa32 and mesa64 dirs)
3) Install Mesa 32 bit `sudo cp -vr mesa32/ /opt/`
4) Install Mesa 64 bit `sudo cp -vr mesa64/ /opt/`
5) Set environment variables into `/etc/environment`</br>
```
LD_LIBRARY_PATH="/opt/mesa64/lib/x86_64-linux-gnu:/opt/mesa32/lib/i386-linux-gnu:/opt/mesa64/lib/x86_64-linux-gnu/vdpau:/opt/mesa32/lib/i386-linux-gnu/vdpau"
LIBGL_DRIVERS_PATH="/opt/mesa64/lib/x86_64-linux-gnu/dri:/opt/mesa32/lib/i386-linux-gnu/dri"
VK_LAYER_PATH="/opt/mesa64/share/vulkan/explicit_layer.d:/opt/mesa32/share/vulkan/explicit_layer.d:/usr/share/vulkan/explicit_layer.d"
VK_ICD_FILENAMES="/opt/mesa64/share/vulkan/icd.d/radeon_icd.x86_64.json:/opt/mesa32/share/vulkan/icd.d/radeon_icd.i686.json:/opt/mesa64/share/vulkan/icd.d/lvp_icd.x86_64.json:/opt/mesa32/share/vulkan/icd.d/lvp_icd.i686.json"
LIBVA_DRIVERS_PATH="/opt/mesa64/lib/x86_64-linux-gnu/dri:/opt/mesa32/lib/i386-linux-gnu/dri"
#VK_INSTANCE_LAYERS=VK_LAYER_MESA_overlay
```

PS: Sometimes need to clean shader caches - `rm -rfv  ~/.cache/radv_builtin_shaders* ~/.cache/mesa_shader_cache* ~/.local/share/Steam/steamapps/shadercache/*`

To check:</br>

PS: Please remove mesa-vdpau because it will crash applications that use it (like VLC) - it can happen due this Mesa build use newer LLVM but by some reason mesa-vdpau package from Debian repository also try use this newer LLVM and crash due it should try to use older one

1) OpenGL, package `mesa-utils` - `glxinfo | grep OpenGL`
2) VA-API, package `vainfo` - `vainfo`
3) VDPAU, package `vdpauinfo` - `vdpauinfo`
4) Vulkan, package `vulkan-tools` - `vulkaninfo`

To uninstall:
1) Remove environment variables from /etc/environment
2) Remove Mesa from /opt/ - `rm -rf /opt/mesa32 /opt/mesa64`

To fix flatpak packages (it can crash startup):
1) `sudo flatpak override --unset-env=LD_LIBRARY_PATH`
2) `sudo flatpak override --unset-env=LIBGL_DRIVERS_PATH`
3) `sudo flatpak override --unset-env=VK_LAYER_PATH`
4) `sudo flatpak override --unset-env=VK_ICD_FILENAMES`
5) `sudo flatpak override --unset-env=LIBVA_DRIVERS_PATH`
