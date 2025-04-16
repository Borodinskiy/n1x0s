{ lsDir, ... }:
{
  imports = lsDir ./. ++ lsDir ./programs ++ lsDir ./window-manager;
}
