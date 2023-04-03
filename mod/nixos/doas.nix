{ ... }:

# Again, OpenBSD thing is better!
{
  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        # However, this is not so secure.
        # https://github.com/Duncaen/OpenDoas#persisttimestamptimeout
        { groups = [ "wheel" ]; persist = true; }
      ];
    };
  };
}
