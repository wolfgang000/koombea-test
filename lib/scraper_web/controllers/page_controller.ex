defmodule ScraperWeb.PageController do
  use ScraperWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    redirect(conn, to: ~p"/web_pages/")
  end
end
