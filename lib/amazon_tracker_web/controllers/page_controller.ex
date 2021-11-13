defmodule AmazonTrackerWeb.PageController do
  use AmazonTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
