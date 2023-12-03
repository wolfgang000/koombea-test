defmodule Scraper.CoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scraper.Core` context.
  """

  @doc """
  Generate a web_page.
  """
  def web_page_fixture(attrs \\ %{}) do
    {:ok, web_page} =
      attrs
      |> Enum.into(%{
        link: "https://www.google.com/"
      })
      |> Scraper.Core.create_web_page()

    web_page
  end
end
