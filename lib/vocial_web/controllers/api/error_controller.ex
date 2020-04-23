defmodule VocialWeb.Api.ErrorController do
  use VocialWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(500)
    |> put_view(VocialWeb.ErrorView)
    |> render("500.json", %{})
  end
end
