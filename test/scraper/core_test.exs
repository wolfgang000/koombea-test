defmodule Scraper.CoreTest do
  use Scraper.DataCase

  alias Scraper.Core

  describe "web_pages" do
    alias Scraper.Core.WebPage

    import Scraper.CoreFixtures

    @invalid_attrs %{link: nil}

    test "list_web_pages/0 returns all web_pages" do
      web_page = web_page_fixture()
      assert Core.list_web_pages() == [web_page]
    end

    test "get_web_page!/1 returns the web_page with given id" do
      web_page = web_page_fixture()
      assert Core.get_web_page!(web_page.id) == web_page
    end

    test "create_web_page/1 with valid data creates a web_page" do
      valid_attrs = %{link: "some link"}

      assert {:ok, %WebPage{} = web_page} = Core.create_web_page(valid_attrs)
      assert web_page.link == "some link"
    end

    test "create_web_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_web_page(@invalid_attrs)
    end

    test "update_web_page/2 with valid data updates the web_page" do
      web_page = web_page_fixture()
      update_attrs = %{link: "some updated link"}

      assert {:ok, %WebPage{} = web_page} = Core.update_web_page(web_page, update_attrs)
      assert web_page.link == "some updated link"
    end

    test "update_web_page/2 with invalid data returns error changeset" do
      web_page = web_page_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_web_page(web_page, @invalid_attrs)
      assert web_page == Core.get_web_page!(web_page.id)
    end

    test "delete_web_page/1 deletes the web_page" do
      web_page = web_page_fixture()
      assert {:ok, %WebPage{}} = Core.delete_web_page(web_page)
      assert_raise Ecto.NoResultsError, fn -> Core.get_web_page!(web_page.id) end
    end

    test "change_web_page/1 returns a web_page changeset" do
      web_page = web_page_fixture()
      assert %Ecto.Changeset{} = Core.change_web_page(web_page)
    end
  end
end
