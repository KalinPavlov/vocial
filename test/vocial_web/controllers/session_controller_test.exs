defmodule Vocial.SessionControllerTest do
  use VocialWeb.ConnCase

  alias Vocial.Accounts

  @valid_create_attrs %{
    username: "test",
    email: "test@test.com",
    password: "test",
    password_confirmation: "test"
  }

  setup %{conn: conn} do
    {:ok, user} = Accounts.create_user(@valid_create_attrs)
    {:ok, conn: conn, user: user}
  end

  test "GET /sessions/new", %{conn: conn} do
    conn = get(conn, "/sessions/new")
    assert html_response(conn, 200) =~ "Login"
  end

  test "POST /sessions with valid data", %{conn: conn, user: user} do
    conn = post conn, "/sessions", %{session: %{username: user.username, password: "test"}}
    assert redirected_to(conn) == "/"
    assert Plug.Conn.get_session(conn, :user)
  end

  test "POST /sessions with invalid data", %{conn: conn, user: user} do
    conn = post conn, "/sessions", %{session: %{username: user.username, password: "fail"}}
    assert html_response(conn, 200)
    assert is_nil(Plug.Conn.get_session(conn, :user))
  end

  test "DELETE /sessions/:id", %{conn: conn, user: user} do
    conn = post conn, "/sessions", %{session: %{username: user.username, password: "test"}}
    assert Plug.Conn.get_session(conn, :user)
    conn = delete(conn, "/sessions/#{user.id}")
    assert is_nil(Plug.Conn.get_session(conn, :user))
  end
end
