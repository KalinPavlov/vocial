defmodule VocialWeb.UserController do
  use VocialWeb, :controller

  alias Vocial.Accounts

  def new(conn, _) do
    user_changeset = Accounts.new_user()
    render(conn, "new.html", user: user_changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created!")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, changeset} ->
        conn
        |> put_flash(:info, "Failed to create user!")
        |> render("new.html", user: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    with user <- Accounts.get_user!(id), do: render(conn, "show.html", user: user)
  end

  def generate_api_key(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    case Accounts.generate_api_key(user) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Updated API key for user!")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, _} ->
        conn
        |> put_flash(:info, "Failed to generate API key for user!")
        |> redirect(to: Routes.user_path(conn, :show, user))
    end
  end
end
