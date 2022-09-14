{ config, lib, pkgs, ... }: {
  options.modules.hardware.gpu.nvidia.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
    description = ''
      Whether to enable Nvidia GPU support.
    '';
  };
  config = lib.mkIf config.modules.hardware.gpu.nvidia.enable {
    boot.kernelParams = [
      # If the Spectre V2 mitigation is necessary, some performance may be recovered by setting the
      # NVreg_CheckPCIConfigSpace kernel module parameter to 0. This will disable the NVIDIA driver's
      # sanity checks of GPU PCI config space at various entry points, which were originally required
      # to detect and correct config space manipulation done by X server versions prior to 1.7.
      "nvidia.NVreg_CheckPCIConfigSpace=0"
      # Enable the PAT feature [5], which affects how memory is allocated. PAT was first introduced in
      # Pentium III [6] and is supported by most newer CPUs (see wikipedia:Page attribute table#Processors).
      # If your system can support this feature, it should improve performance.
      "nvidia.NVreg_UsePageAttributeTable=1"
      # Enable PCIe Gen 3.x support.
      "nvidia.NVreg_EnablePCIeGen3=1"
    ];

    environment.systemPackages = with pkgs; [
      moonlight-embedded # Open source implementation of NVIDIA's GameStream
      moonlight-qt # Play your PC games on almost any device
      nvtop # A (h)top like like task monitor for NVIDIA GPUs
      pciutils # A collection of programs for inspecting and manipulating configuration of PCI devices
    ]; # The set of packages that appear in /run/current-system/sw. These packages are automatically available to all users, and are automatically updated every time you rebuild the system configuration
    #environment.variables.__GL_LOG_MAX_ANISO = "0"; # Anisotropic texture filtering, 0-4, 0x, 2x, 4x, 8x, 16x
    #environment.variables.__GL_SHADER_DISK_CACHE = "1"; # Enables or disables the shader cache for direct rendering.
    #environment.variables.__GL_IGNORE_GLSL_EXT_REQS = "1";
    #environment.variables.__GL_THREADED_OPTIMIZATIONS ="1";
    #environment.variables.__GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
    #environment.variables.__GL_YIELD = "NOTHING";
    #environment.variables.__GL_SYNC_TO_VBLANK = "0"; # Can break mpv
    #environment.variables.__GL_FSAA_MODE = "0";
    #environment.variables.__GL_MaxFramesAllowed = "0"; # Ultra low latency mode https://devtalk.nvidia.com/default/topic/1067593/linux/how-to-turn-on-low-latency-mode-max-pre-render-frames-on-linux-/
    #environment.variables.GDK_DPI_SCALE = "0.5";
    #environment.variables.QT_FONT_DPI = "141";

    hardware.nvidia.modesetting.enable = true; # Enable kernel modesetting when using the NVIDIA proprietary driver
    hardware.nvidia.nvidiaSettings = true; # Whether to add nvidia-settings, NVIDIA's GUI configuration tool, to systemPackages
    hardware.nvidia.package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable; # The NVIDIA X11 derivation to use
    hardware.opengl.enable = true; # Whether to enable OpenGL drivers.This is needed to enable OpenGL support in X11 systems, as well as for Wayland compositors like sway and Weston
    hardware.opengl.driSupport = true; # Whether to enable accelerated OpenGL rendering through the Direct Rendering Interface (DRI)
    hardware.opengl.driSupport32Bit = true; # On 64-bit systems, whether to support Direct Rendering for 32-bit applications (such as Wine)
    hardware.opengl.extraPackages = with pkgs; [
      glxinfo # Test utilities for OpenGL
      libdrm # Direct Rendering Manager library and headers
      libglvnd # The GL Vendor-Neutral Dispatch library
      libva # An implementation for VA-API (Video Acceleration API)
      libva-utils # A collection of utilities and examples for VA-API
      libvdpau # Library to use the Video Decode and Presentation API for Unix (VDPAU)
      libvdpau-va-gl # VDPAU driver with OpenGL/VAAPI backend
      mesa.drivers # An open source 3D graphics library
      nvidia-vaapi-driver # A VA-API implemention using NVIDIA's NVDEC
      vaapiVdpau # VDPAU driver for the VAAPI library
      vdpauinfo # Tool to query the Video Decode and Presentation API for Unix (VDPAU) abilities of the system
      vulkan-extension-layer # Layers providing Vulkan features when native support is unavailable
      vulkan-loader # LunarG Vulkan loader
      vulkan-tools # Khronos official Vulkan Tools and Utilities
      vulkan-tools-lunarg # LunarG Vulkan Tools and Utilities
      vulkan-validation-layers # The official Khronos Vulkan validation layers
    ]; # Additional packages to add to OpenGL drivers.This can be used to add OpenCL drivers, VA-API/VDPAU drivers etc
    hardware.opengl.extraPackages32 = with pkgs.driversi686Linux; [
      glxinfo # Test utilities for OpenGL
      libvdpau-va-gl # VDPAU driver with OpenGL/VAAPI backend
      mesa.drivers # An open source 3D graphics library
      vaapiVdpau # VDPAU driver for the VAAPI library
      vdpauinfo # Tool to query the Video Decode and Presentation API for Unix (VDPAU) abilities of the system
    ]; # Additional packages to add to 32-bit OpenGL drivers on 64-bit systems. Used when driSupport32Bit is set. This can be used to add OpenCL drivers, VA-API/VDPAU drivers etc

    hardware.pulseaudio.support32Bit = true; # Whether to include the 32 - bit pulseaudio libraries in the system or not

    services.xserver.videoDrivers = [ "nvidia" ]; # The names of the video drivers the configuration supports

    virtualisation.docker.enableNvidia = true; # Enable nvidia-docker wrapper, supporting NVIDIA GPUs inside docker containers
    virtualisation.podman.enableNvidia = true; # Enable use of NVidia GPUs from within podman containers
  };
}
