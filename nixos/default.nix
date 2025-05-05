{ lsDir, ... }:
{
  imports =
    lsDir ./.
    ++ lsDir ./desktop
    ++ lsDir ./graphics
    ++ lsDir ./network-drivers
    ++ lsDir ./programs
    ++ lsDir ./services;
}
