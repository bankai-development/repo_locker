defmodule RepoLocker.Server.LockerServerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias RepoLocker.Servers.LockerServer

  @server LockerServer.init([])

  defp set_event_header(conn, event_name) do
    Plug.Conn.put_req_header(conn, "x-github-event", event_name)
  end

  defp read_example(filename) do
    filepath = Path.expand("./test/servers/example_requests/" <> filename)
    filepath
      |> File.read!
      |> Jason.decode!
  end

  test "server returns healthy and 200" do
    conn = conn(:get, "/healthz")
    conn = LockerServer.call(conn, @server)

    assert conn.status == 200
  end

  test "call lock on a repository when receiving a callback" do
    event_data = read_example("repository_webhook_event.json")
    conn = conn(:post, "/notifications", event_data)
    conn = conn
      |> set_event_header("repository")
      |> LockerServer.call(@server)
    
    assert conn.status == 204
  end

  test "do not respond to any other repository action type" do
    event_data = read_example("repository_webhook_event.json")
    event_data_changed = Map.put(event_data, "action", "not-created-value")
    
    conn = conn(:post, "/notifications", event_data_changed)
    conn = conn
      |> set_event_header("repository")
      |> LockerServer.call(@server)
    
    assert conn.status == 404
  end
  
  test "do not respond to any other repository notification type" do
    event_data = read_example("repository_webhook_event.json")
    conn = conn(:post, "/notifications", event_data)
    conn = conn
      |> set_event_header("invalid-repository")
      |> LockerServer.call(@server)
    
    assert conn.status == 404
  end
end