defmodule ScraperWeb.WebPageControllerTest do
  use ExUnit.Case, async: false
  use ScraperWeb.ConnCase

  import Mock

  @create_attrs %{url: "https://google.com/"}
  @invalid_attrs %{url: nil}

  setup :register_and_log_in_user

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
      with_mock HTTPoison,
        get: fn _url ->
          {:ok,
           %HTTPoison.Response{
             status_code: 200,
             body: "<html><a href=\"https://www.w3schools.com\"> Visit W3Schools.com! </a></html>"
           }}
        end do
        conn = post(conn, ~p"/web_pages", web_page: @create_attrs)

        assert %{id: id} = redirected_params(conn)
        assert redirected_to(conn) == ~p"/web_pages/#{id}"

        conn = get(conn, ~p"/web_pages/#{id}")
        assert html_response(conn, 200) =~ "https://google.com/"
        assert html_response(conn, 200) =~ "Visit W3Schools.com!"
        assert html_response(conn, 200) =~ "https://www.w3schools.com"

        conn = get(conn, ~p"/web_pages/")
        assert html_response(conn, 200) =~ "https://google.com/"
        assert html_response(conn, 200) =~ "1"
      end
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/web_pages", web_page: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Web page"
    end
  end
end
