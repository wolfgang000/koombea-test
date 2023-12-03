defmodule Scraper.Repo.Migrations.CreateWebPages do
  use Ecto.Migration

  def change do
    create table(:web_pages) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :url, :string

      timestamps(type: :utc_datetime)
    end
  end
end
