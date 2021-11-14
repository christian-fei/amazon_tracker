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

    refs = Enum.map(products, fn p -> AmazonTracker.Amazon.Scraper.start_link(p.url) end)

    updated_product_infos =
      Enum.map(refs, fn {:ok, pid} ->
        {:ok, p} = GenServer.call(pid, :scrape)
        p
      end)

    updated_products =
      Enum.with_index(products)
      |> Enum.map(fn {p, index} ->
        Ecto.Changeset.change(
          p,
          updated_product_infos |> Enum.at(index) |> Map.take([:title, :url, :image])
        )
      end)
      |> Enum.map(fn change ->
        AmazonTracker.Repo.update(change)
      end)

    Enum.with_index(updated_product_infos)
    |> Enum.map(fn {p, index} ->
      AmazonTracker.Repo.insert(%AmazonTracker.Amazon.Price{
        product_id: Enum.at(products, index).id,
        price: p.price
      })
    end)

    Process.send_after(self(), :loop, 1_000 * 60 * 30)
    IO.puts("updated products")
    {:noreply, state}
  end
end
