defmodule Scraper.Core.WebPageLink do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scraper.Core.WebPage

  schema "web_pages_links" do
    field :body, :string
    field :href, :string
    belongs_to :web_page, WebPage
  end

  @doc false
  def changeset(web_page_link, attrs) do
    web_page_link
    |> cast(attrs, [:href, :body, :web_page_id])
    |> validate_required([:href, :body, :web_page_id])
    |> foreign_key_constraint(:web_page_id)
  end
end
