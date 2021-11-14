defmodule AmazonTracker.Amazon.Tracker do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, [])
  end

  @impl GenServer
  def init(_args) do
    state = %{}
    send(self(), :loop)
    {:ok, state}
  end

  @impl true
  def handle_info(:loop, state) do
    IO.puts("running tracker")
    products = AmazonTracker.Repo.all(AmazonTracker.Amazon.Product)
    products |> Enum.map(fn p -> p.title <> " - " <> p.url end) |> Enum.map(&IO.inspect/1)

    refs = Enum.map(products, fn p -> AmazonTracker.Amazon.Scraper.start_link(p.url) end)

    updated_products = Enum.map(refs, fn {:ok, pid} -> GenServer.call(pid, :scrape) end)
    IO.inspect(updated_products)

    Process.send_after(self(), :loop, 1_000 * 60 * 30)
    {:noreply, state}
  end
end
