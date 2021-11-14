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

    updated_product_infos =
      Enum.map(products, fn p ->
        Task.Supervisor.async(AmazonTracker.TaskSupervisor, fn ->
          {:ok, p} = AmazonTracker.Amazon.Scraper.scrape(p)
          p
        end)
      end)
      |> Enum.map(&Task.await/1)

    IO.inspect(updated_product_infos)

    update_products(products, updated_product_infos)
    insert_prices(products, updated_product_infos)

    Process.send_after(self(), :loop, 1_000 * 60 * 30)
    IO.puts("updated products")
    {:noreply, state}
  end

  defp update_products(products, updated_product_infos) do
    Enum.with_index(products)
    |> Enum.map(fn {p, index} ->
      Ecto.Changeset.change(
        p,
        updated_product_infos |> Enum.at(index) |> Map.take([:title, :url, :image])
      )
      |> AmazonTracker.Repo.update()
    end)
  end

  defp insert_prices(products, updated_product_infos) do
    Enum.with_index(updated_product_infos)
    |> Enum.map(fn {p, index} ->
      AmazonTracker.Repo.insert(%AmazonTracker.Amazon.Price{
        product_id: Enum.at(products, index).id,
        price: p.price
      })
    end)
  end
end
