defmodule AmazonTrackerWeb.PageController do
  use AmazonTrackerWeb, :controller

  def index(conn, _params) do
    # render(conn, "index.html")
    redirect(conn, to: "/products")
  end
end
