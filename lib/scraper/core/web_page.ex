defmodule Scraper.Core.WebPage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Scraper.Core.WebPageLink
  alias Scraper.Accounts.User

  schema "web_pages" do
    field :url, :string
    has_many :links, WebPageLink
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(web_page, attrs) do
    web_page
    |> cast(attrs, [:url, :user_id])
    |> validate_format(
      :url,
      ~r/^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$/,
      message: "invalid url"
    )
    |> validate_required([:url, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
