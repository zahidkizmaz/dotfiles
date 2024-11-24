{ ... }:
{
  virtualisation.waydroid.enable = true;

  # Only for the first time after rebuild switch
  # Fetch WayDroid images.
  # You can add the parameters "-s GAPPS -f" to have GApps support.
  # $ sudo waydroid init

  # Usage
  # Start the WayDroid LXC container
  # sudo systemctl start waydroid-container
  #
  # You'll know it worked by checking the journal You should see "Started Waydroid Container".
  # sudo journalctl -u waydroid-container
  #
  # Start WayDroid session
  # You'll know it is finished when you see the message "Android with user 0 is ready".
  # waydroid session start
}
