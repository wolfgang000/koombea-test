defmodule Scraper.Core.WebPage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scraper.Core.WebPageLink

  schema "web_pages" do
    field :link, :string
    has_many :links, WebPageLink

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(web_page, attrs) do
    web_page
    |> cast(attrs, [:link])
    |> validate_format(
      :link,
      ~r/^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$/,
      message: "invalid url"
    )
    |> validate_required([:link])
  end
end
