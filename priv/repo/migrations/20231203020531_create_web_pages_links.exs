defmodule Scraper.Repo.Migrations.CreateWebPagesLinks do
  use Ecto.Migration

  def change do
    create table(:web_pages_links) do
      add :href, :text, null: false
      add :body, :text, null: false
      add :web_page_id, references(:web_pages, on_delete: :delete_all), null: false
    end
  end
end
