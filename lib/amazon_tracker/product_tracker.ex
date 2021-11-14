defmodule AmazonTracker.ProductTracker do
  use GenServer

  def start_link(url) do
    GenServer.start_link(__MODULE__, url, [])
  end

  @impl true
  def init(url) do
    state = %{url: url, title: nil, price: nil, image: nil, body: nil}
    send(self(), :scrape)
    {:ok, state}
  end

  @impl true
  def handle_info(:scrape, state) do
    {:ok, body} = AmazonTracker.Amazon.Scraper.scrape(state.url)
    IO.puts("scraped " <> state.url)

    {:ok, document} = Floki.parse_document(body)

    title = document |> Floki.find("#productTitle") |> Floki.text() |> String.trim()

    price =
      document
      |> Floki.find(".apexPriceToPay .a-offscreen")
      |> Floki.text()
      |> String.trim()
      |> String.replace("€", "")
      |> String.to_float()

    image =
      document
      |> Floki.find("#imgTagWrapperId img")
      |> Floki.attribute("src")
      |> Enum.at(0, "")

    state = Map.put(state, :body, body)
    state = Map.put(state, :price, price)
    state = Map.put(state, :title, title)
    state = Map.put(state, :image, image)
    state = Map.put(state, :body, body)

    {:noreply, state}
  end

  @impl true
  def handle_call(:product, _from, state) do
    product = %AmazonTracker.Amazon.Product{
      url: state.url,
      price: state.price,
      title: state.title,
      image: state.image
    }

    {:reply, {:ok, product}, state}
  end
end
