defmodule Scraper.Core.WebPage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "web_pages" do
    field :link, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(web_page, attrs) do
    web_page
    |> cast(attrs, [:link])
    |> validate_required([:link])
  end
end
