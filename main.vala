using GLib;

int main () {
    try {
        GameMode.Client gm = Bus.get_proxy_sync (BusType.SESSION,
                                                 "com.feralinteractive.GameMode",
                                                 "/com/feralinteractive/GameMode");

		gm.game_registered.connect ((pid, path) => {
            stdout.printf (@"game registered $pid ($path)\n");
        });

		gm.game_unregistered.connect ((pid, path) => {
            stdout.printf (@"game un-registered $pid ($path)\n");
        });
		
        var games = gm.list_games ();
        foreach (GameMode.GameInfo info in games) {
            stdout.printf ("Pid:  %i\n", info.pid);
			stdout.printf ("Path: %s\n", info.path);
        }

        var loop = new MainLoop ();
        loop.run ();

    } catch (IOError e) {
        stderr.printf ("%s\n", e.message);
        return 1;
    } catch (GLib.DBusError e) {
        stderr.printf ("%s\n", e.message);
        return 1;
    }

    return 0;
}