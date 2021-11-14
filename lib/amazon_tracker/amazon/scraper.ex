defmodule AmazonTracker.Amazon.Scraper do
  use GenServer

  def start_link(url) do
    GenServer.start_link(__MODULE__, url, [])
  end

  @impl true
  def init(url) do
    state = %{url: url, title: nil, price: nil, image: nil}
    {:ok, state}
  end

  @impl true
  def handle_call(:scrape, _from, state) do
    IO.puts("scraping " <> state.url)
    {:ok, body} = get_body(state.url)

    {:ok, document} = Floki.parse_document(body)

    product = product_from_document(document, state.url)

    # state = Map.put(state, :price, product.price)
    state = Map.put(state, :title, product.title)
    state = Map.put(state, :image, product.image)

    IO.puts("scraped " <> state.url)
    {:reply, {:ok, product}, state}
  end

  defp get_body(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :not_found}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp product_from_document(document, url) do
    title = document |> Floki.find("#productTitle") |> Floki.text() |> String.trim()

    # price =
    #   document
    #   |> Floki.find(".apexPriceToPay .a-offscreen")
    #   |> Floki.text()
    #   |> String.trim()
    #   |> String.replace("€", "")
    #   |> String.to_float()

    image =
      document
      |> Floki.find("#imgTagWrapperId img")
      |> Floki.attribute("src")
      |> Enum.at(0, "")

    %AmazonTracker.Amazon.Product{
      url: url,
      # price: price,
      title: title,
      image: image
    }
  end
end
