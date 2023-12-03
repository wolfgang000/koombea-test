defmodule ScraperWeb.WebPageHTML do
  use ScraperWeb, :html

  embed_templates "web_page_html/*"

  @doc """
  Renders a web_page form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def web_page_form(assigns)
end
