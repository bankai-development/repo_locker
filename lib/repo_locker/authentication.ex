defmodule RepoLocker.Authentication do
  @moduledoc """
  Simple Authentication Module
  """
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    if basic_auth_disabled(conn) do
      conn
    else
      [user, pass] = decode_basic_auth(conn)
      validate_user(conn, user, pass)
    end
  end

  def basic_user do
    System.get_env("REPO_LOCKER_USER")
  end

  def basic_pass do
    System.get_env("REPO_LOCKER_PASS")
  end

  def basic_auth_disabled(conn) do
    List.keyfind(conn.req_headers, "x-force-auth", 0) == nil && Mix.env() == :test
  end

  defp decode_basic_auth(conn) do
    case List.keyfind(conn.req_headers, "authorization", 0) do
      {_key, creds} ->
        creds
        |> String.split()
        |> List.last()
        |> Base.decode64!(padding: false)
        |> String.split(":")

      nil ->
        [nil, nil]
    end
  end

  defp validate_user(conn, user, pass) do
    if user == basic_user() && pass == basic_pass() do
      conn
    else
      conn
      |> send_resp(401, "invalid user")
      |> halt()
    end
  end
end
