/* Generated by vala-dbus-binding-tool 1.0-aa2fb. Do not modify! Haha, but I did. Beat me! */
/* Generated with: vala-dbus-binding-tool --no-synced --api-path=com.feralinteractive.GameMode.xml */
using GLib;

[DBus (name = "com.feralinteractive.GameMode.Game", timeout = 120000)]
public interface GameMode.Game : GLib.Object {

	[DBus (name = "ProcessId")]
	public abstract int process_id {  get; }

	[DBus (name = "Exectuable")]
	public abstract string exectuable { owned get; }
}

[DBus (name = "com.feralinteractive.GameMode", timeout = 120000)]
public interface GameMode.Client : GLib.Object {

	[DBus (name = "ClientCount")]
	public abstract int client_count {  get; }

	[DBus (name = "RegisterGame")]
	public abstract int register_game(int pid) throws DBusError, IOError;

	[DBus (name = "UnregisterGame")]
	public abstract int unregister_game(int pid) throws DBusError, IOError;

	[DBus (name = "QueryStatus")]
	public abstract int query_status(int pid) throws DBusError, IOError;

	[DBus (name = "RegisterGameByPID")]
	public abstract int register_game_by_pid(int pid, int requestor) throws DBusError, IOError;

	[DBus (name = "UnregisterGameByPID")]
	public abstract int unregister_game_by_pid(int pid, int requestor) throws DBusError, IOError;

	[DBus (name = "QueryStatusByPID")]
	public abstract int query_status_by_pid(int pid, int requestor) throws DBusError, IOError;

	[DBus (name = "RefreshConfig")]
	public abstract int refresh_config() throws DBusError, IOError;

	[DBus (name = "ListGames")]
	public abstract GameInfo[] list_games() throws DBusError, IOError;

	[DBus (name = "GameRegistered")]
	public signal void game_registered(int pid, GLib.ObjectPath path);

	[DBus (name = "GameUnregistered")]
	public signal void game_unregistered(int pid, GLib.ObjectPath path);
}

public struct GameMode.GameInfo {
	public int pid;
	public GLib.ObjectPath path;
}

public class GameMode.PidList {

	private Client client;
	private HashTable<int, GLib.ObjectPath> _pids;

	public PidList() throws IOError, DBusError {
		client = Bus.get_proxy_sync (BusType.SESSION,
									 "com.feralinteractive.GameMode",
									 "/com/feralinteractive/GameMode");
		
		client.game_registered.connect(this.on_game_registered);
		client.game_unregistered.connect(this.on_game_unregistered);

		_pids = new HashTable<int, GLib.ObjectPath>(int_hash, int_equal);

		var games = client.list_games ();
        foreach (GameMode.GameInfo info in games) {
			_pids.insert(info.pid, info.path);
        }
		
	}

	/* public */
	public int[] pids {
		owned get {
			return _pids.get_keys_as_array();
		}
	}
	
	public bool contains(int pid) {
		return pid in _pids;
	}

	[Signal (detailed = true)]
    public signal void changed(int pid);
	
	/* Signals */
	private void on_game_registered(int pid,  GLib.ObjectPath path) {
		_pids.insert(pid, path);
		changed["added"](pid);
	}

	private void on_game_unregistered(int pid, GLib.ObjectPath path) {
		_pids.remove(pid);
		changed["removed"](pid);
	}
}