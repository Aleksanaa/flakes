{ ... }:

# Generates systemd user service for autostart purpose
# In this way they are better managed by systemd
{
  func = { Desc, Service, After? [] }: {
    Unit = {
      Description = Desc;
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ] ++ After;
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      WorkingDirectory = "~";
    } // Service;
  };
}
