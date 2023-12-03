defmodule Scraper.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias Scraper.Repo

  alias Scraper.Core.WebPage
  alias Scraper.Core.WebPageLink

  @doc """
  Returns the list of web_pages.

  ## Examples

      iex> list_web_pages()
      [%WebPage{}, ...]

  """
  def list_web_pages(user_id) do
    Repo.all(from wb in WebPage,
      left_join: l in assoc(wb, :links),
      where: wb.user_id == ^user_id,
      group_by: wb.id,
      select: %{
        id: wb.id,
        link: wb.link,
        links_count: count(l.id),
      }
    )
  end

  def get_links_from_page(url) do
    with {:ok,
          %HTTPoison.Response{
            status_code: 200,
            body: body
          }} <- HTTPoison.get(url),
         {:ok, document} <- Floki.parse_document(body)  do
      links =
        document
        |> Floki.find("a")
        |> Enum.map(fn {_tag_name, attributes, children_nodes} ->
          href_element =
            Enum.find(
              attributes,
              fn
                {"href", _url} -> true
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
          %{href: href, body: body}
        end)

      {:ok, links}
    end
  end

  def save_page_links_bulk(links, web_page_id) do
    links
    |> Enum.map(fn link ->
      Map.put(link, :web_page_id, web_page_id)
    end)
    |> Enum.map(fn link -> WebPageLink.changeset(%WebPageLink{}, link) end)
    |> Enum.filter(fn changeset -> changeset.valid? end)
    |> Enum.map(fn link -> link.changes end)
    |> create_web_page_links()
  end

  def save_page_links(web_page) do
    with {:ok, [_ | _] = links} <- get_links_from_page(web_page.link) do
      save_page_links_bulk(links, web_page.id)
    end
  end

  @doc """
  Gets a single web_page.

  Raises `Ecto.NoResultsError` if the Web page does not exist.

  ## Examples

      iex> get_web_page!(123)
      %WebPage{}

      iex> get_web_page!(456)
      ** (Ecto.NoResultsError)

  """
  def get_web_page!(id), do: WebPage |> Repo.get!(id) |> Repo.preload([:links])

  def get_web_page!(id, user_id),
    do: WebPage |> Repo.get_by!([{:id, id}, {:user_id, user_id}]) |> Repo.preload([:links])

  @doc """
  Creates a web_page.

  ## Examples

      iex> create_web_page(%{field: value})
      {:ok, %WebPage{}}

      iex> create_web_page(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_web_page(attrs \\ %{}) do
    %WebPage{}
    |> WebPage.changeset(attrs)
    |> Repo.insert()
  end

  def create_web_page_links(links) do
    Repo.insert_all(WebPageLink, links)
  end

  @doc """
  Updates a web_page.

  ## Examples

      iex> update_web_page(web_page, %{field: new_value})
      {:ok, %WebPage{}}

      iex> update_web_page(web_page, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_web_page(%WebPage{} = web_page, attrs) do
    web_page
    |> WebPage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a web_page.

  ## Examples

      iex> delete_web_page(web_page)
      {:ok, %WebPage{}}

      iex> delete_web_page(web_page)
      {:error, %Ecto.Changeset{}}

  """
  def delete_web_page(%WebPage{} = web_page) do
    Repo.delete(web_page)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking web_page changes.

  ## Examples

      iex> change_web_page(web_page)
      %Ecto.Changeset{data: %WebPage{}}

  """
  def change_web_page(%WebPage{} = web_page, attrs \\ %{}) do
    WebPage.changeset(web_page, attrs)
  end
end
