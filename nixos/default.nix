{ lsDir, ... }:
{
  imports =
    lsDir ./.
    ++ lsDir ./desktop
    ++ lsDir ./graphics
    ++ lsDir ./programs
    ++ lsDir ./services;
}
