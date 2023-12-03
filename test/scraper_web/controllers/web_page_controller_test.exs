defmodule ScraperWeb.WebPageControllerTest do
  use ScraperWeb.ConnCase

  import Scraper.CoreFixtures

  @create_attrs %{link: "https://google.com/"}
  @invalid_attrs %{link: nil}

  describe "index" do
    test "lists all web_pages", %{conn: conn} do
      conn = get(conn, ~p"/web_pages")
      assert html_response(conn, 200) =~ "Listing Web pages"
    end
  end

  describe "new web_page" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/web_pages/new")
      assert html_response(conn, 200) =~ "New Web page"
    end
  end

  describe "create web_page" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/web_pages", web_page: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/web_pages/#{id}"

      conn = get(conn, ~p"/web_pages/#{id}")
      assert html_response(conn, 200) =~ "Web page #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/web_pages", web_page: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Web page"
    end
  end

  describe "edit web_page" do
    setup [:create_web_page]

    test "renders form for editing chosen web_page", %{conn: conn, web_page: web_page} do
      conn = get(conn, ~p"/web_pages/#{web_page}/edit")
      assert html_response(conn, 200) =~ "Edit Web page"
    end
  end

  describe "delete web_page" do
    setup [:create_web_page]

    test "deletes chosen web_page", %{conn: conn, web_page: web_page} do
      conn = delete(conn, ~p"/web_pages/#{web_page}")
      assert redirected_to(conn) == ~p"/web_pages"

      assert_error_sent 404, fn ->
        get(conn, ~p"/web_pages/#{web_page}")
      end
    end
  end

  defp create_web_page(_) do
    web_page = web_page_fixture()
    %{web_page: web_page}
  end
end
