defmodule AmazonTracker.Amazon.Scraper do
  def scrape(product) do
    IO.puts("scraping " <> product.url)
    {:ok, body} = get_body(product.url)

    {:ok, document} = Floki.parse_document(body)

    infos =
      try do
        product_from_document(document, product)
      rescue
        e -> product
      end

    IO.puts("scraped " <> infos.url)
    {:ok, infos}
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

  defp product_from_document(document, product) do
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

    %{
      url: product.url,
      price: price,
      title: title,
      image: image
    }
  rescue
    e ->
      IO.puts("failed to scrape " ++ product.url)
      IO.inspect(e)
      product
  end
end
