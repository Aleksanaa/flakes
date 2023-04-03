{ ... }:

# enable mandoc and disable man-db system wide.
# we like the unix way instead of GNU, 
# and openbsd has good social credits, right?
{
  documentation = {
    man = {
      mandoc = {
        enable = true;
        manPath = [ "share/man" "share/man/zh_CN" ];
      };
      man-db.enable = false;
    };
    info.enable = false;
    doc.enable = false;
  };
}
