defmodule ScraperWeb.WebPageController do
  use ScraperWeb, :controller

  alias Scraper.Core
  alias Scraper.Core.WebPage

  def index(conn, _params) do
    user = conn.assigns.current_user

    web_pages = Core.list_web_pages(user.id)
    render(conn, :index, web_pages: web_pages)
  end

  def new(conn, _params) do
    changeset = Core.change_web_page(%WebPage{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"web_page" => web_page_params}) do
    user = conn.assigns.current_user

    case Core.create_web_page(web_page_params |> Map.put("user_id", user.id)) do
      {:ok, web_page} ->
        Core.save_page_links(web_page)

        conn
        |> put_flash(:info, "Web page created successfully.")
        |> redirect(to: ~p"/web_pages/#{web_page}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = conn.assigns.current_user

    web_page = Core.get_web_page!(id, user.id)
    render(conn, :show, web_page: web_page)
  end

  def edit(conn, %{"id" => id}) do
    web_page = Core.get_web_page!(id)
    changeset = Core.change_web_page(web_page)
    render(conn, :edit, web_page: web_page, changeset: changeset)
  end

  def update(conn, %{"id" => id, "web_page" => web_page_params}) do
    web_page = Core.get_web_page!(id)

    case Core.update_web_page(web_page, web_page_params) do
      {:ok, web_page} ->
        conn
        |> put_flash(:info, "Web page updated successfully.")
        |> redirect(to: ~p"/web_pages/#{web_page}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, web_page: web_page, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    web_page = Core.get_web_page!(id)
    {:ok, _web_page} = Core.delete_web_page(web_page)

    conn
    |> put_flash(:info, "Web page deleted successfully.")
    |> redirect(to: ~p"/web_pages")
  end
end
