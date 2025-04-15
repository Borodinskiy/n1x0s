{ lsDir, ... }:
{
  imports =
    lsDir ./desktop-environment
    ++ lsDir ./graphics
    ++ lsDir ./network-drivers
    ++ lsDir ./programs
    ++ lsDir ./services;
}
