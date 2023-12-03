defmodule ScraperWeb.WebPageController do
  use ScraperWeb, :controller

  alias Scraper.Core
  alias Scraper.Core.WebPage
  alias Scraper.Core.WebPageLink

  def index(conn, _params) do
    web_pages = Core.list_web_pages()
    render(conn, :index, web_pages: web_pages)
  end

  def new(conn, _params) do
    changeset = Core.change_web_page(%WebPage{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"web_page" => web_page_params}) do
    case Core.create_web_page(web_page_params) do
      {:ok, web_page} ->
        with {:ok,
              %HTTPoison.Response{
                status_code: 200,
                body: body
              }} <- HTTPoison.get(web_page.link),
             {:ok, document} <- Floki.parse_document(body) do
          document
          |> Floki.find("a")
          |> Enum.map(fn {tag_name, attributes, children_nodes} ->
            href_element =
              Enum.find(
                attributes,
                fn
                  {"href", url} -> true
                  _ -> false
                end
              )

            body =
              case children_nodes do
                [text] when not is_nil(text) and is_bitstring(text) and text != "" ->
                  text
                  |> Codepagex.to_string!(:iso_8859_1, Codepagex.use_utf_replacement())

                _ ->
                  children_nodes
                  |> Floki.raw_html()
                  |> Codepagex.to_string!(:iso_8859_1, Codepagex.use_utf_replacement())
              end

            case href_element do
              {"href", url} when not is_nil(url) and is_bitstring(url) and url != "" ->
                {url, body}

              _ ->
                nil
            end
          end)
          |> Enum.filter(fn
            nil -> false
            _ -> true
          end)
          |> Enum.map(fn {href, body} ->
            %{href: href, body: body, web_page_id: web_page.id}
          end)
          |> Enum.map(fn link -> WebPageLink.changeset(%WebPageLink{}, link) end)
          |> Enum.filter(fn changeset -> changeset.valid? end)
          |> Enum.map(fn link -> link.changes end)
          |> Core.create_web_page_links()
        end

        conn
        |> put_flash(:info, "Web page created successfully.")
        |> redirect(to: ~p"/web_pages/#{web_page}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    web_page = Core.get_web_page!(id)
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
