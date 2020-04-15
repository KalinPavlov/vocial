defmodule VocialWeb.SessionController do
  use VocialWeb, :controller

  alias Vocial.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    with user <- Accounts.get_user_by(username: username),
         {:ok, login_user} <- login(user, password) do
      conn
      |> put_flash(:info, "Logged in successfully!")
      |> put_session(:user, %{
        id: login_user.id,
        username: login_user.username,
        email: login_user.email
      })
      |> redirect(to: "/")
    else
      {:error, _} ->
        conn
        |> put_flash(:info, "Invalid username/password!")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user)
    |> put_flash(:info, "Logged out successfully!")
    |> redirect(to: "/")
  end

  defp login(user, password) do
    cond do
      user && Bcrypt.verify_pass(password, user.encrypted_password) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Bcrypt.no_user_verify()
        {:error, :not_found}
    end
  end
end
