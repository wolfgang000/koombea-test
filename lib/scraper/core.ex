defmodule Scraper.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias Scraper.Repo

  alias Scraper.Core.WebPage

  @doc """
  Returns the list of web_pages.

  ## Examples

      iex> list_web_pages()
      [%WebPage{}, ...]

  """
  def list_web_pages do
    Repo.all(WebPage)
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
  def get_web_page!(id), do: Repo.get!(WebPage, id)

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
