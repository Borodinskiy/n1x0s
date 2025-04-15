{ lsDir, ... }:
{
  imports = lsDir ./programs ++ lsDir ./window-manager;
}
