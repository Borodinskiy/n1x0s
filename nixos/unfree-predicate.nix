{ lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      # Nvidia gpu
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      # Cuda
      "cudatoolkit"
      "cuda-merged"
      "cuda_cuobjdump"
      "cuda_gdb"
      "cuda_nvcc"
      "cuda_nvdisasm"
      "cuda_nvprune"
      "cuda_cccl"
      "cuda_cudart"
      "cuda_cupti"
      "cuda_cuxxfilt"
      "cuda_nvml_dev"
      "cuda_nvrtc"
      "cuda_nvtx"
      "cuda_profiler_api"
      "cuda_sanitizer_api"
      "cudnn"
      "libcublas"
      "libcufft"
      "libcurand"
      "libcusolver"
      "libnvjitlink"
      "libcusparse"
      "libnpp"
      # MS corefonts
      "corefonts"
      "vista-fonts"
      # Steam
      "steam"
      "steam-unwrapped"
      "steam-original"
      "steam-run"
      "steamcmd"
      # Electon bullshitt
      "obsidian"
      # Printer
      "samsung-UnifiedLinuxDriver"
      "samsung-unified-linux-driver"
      "canon-cups-ufr2"
      # Yes
      "discord"
      # For cuda/rocm support
      "blender"
      # Network analysis and request edit tool for web
      "burpsuite"
    ];
}
