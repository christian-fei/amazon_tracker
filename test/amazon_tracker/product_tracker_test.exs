defmodule AmazonTracker.TrackerTest do
  use ExUnit.Case, async: true
  alias AmazonTracker.ProductTracker

  test "x" do
    assert :ok == :ok
    url = "https://www.amazon.it/gp/product/B08DRSHH8T"
    {:ok, pid} = ProductTracker.start_link(url)
    Process.sleep(2_000)
    {:ok, product} = GenServer.call(pid, :product)
    IO.inspect(product)
  end
end
