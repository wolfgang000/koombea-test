defmodule Scraper.Repo.Migrations.CreateWebPages do
  use Ecto.Migration

  def change do
    create table(:web_pages) do
      add :link, :string

      timestamps(type: :utc_datetime)
    end
  end
end
