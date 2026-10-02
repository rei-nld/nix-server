{ config, lib, pkgs, ... }:

{
  # Mandatory: nixpkgs 26.05 declares legacy_390 as
  # `broken = kernel.kernelAtLeast "6.18"`, while that branch's default kernel
  # is 6.18.38. Without this pin the build fails outright. The 390 patches stop
  # at kernel 6.17, so the kernel is capped at 6.12 while GPU support is wanted.
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
    nvidiaSettings = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
  };

  services.xserver = {
    enable = true;
    videoDriver = "nvidia";
  };

  nixpkgs.config.nvidia.acceptLicense = true;
}
