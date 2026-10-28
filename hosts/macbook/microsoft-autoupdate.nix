{ flake, ... }:
with flake.lib;
{
  system.activationScripts.postActivation.text = ''
    # Daily Microsoft AutoUpdate runs are an annoyance when I'm not working
    # for a client that uses Microsoft software. Keep the app available for
    # occasional manual updates, but prevent the periodic background agent.
    mauUid=$(id -u ${macbook.main-user})
    launchctl disable "gui/$mauUid/com.microsoft.update.agent"
    launchctl bootout "gui/$mauUid/com.microsoft.update.agent" 2>/dev/null || true
  '';
}
