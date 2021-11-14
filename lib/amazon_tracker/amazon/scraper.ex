defmodule AmazonTracker.Amazon.Scraper do
  def scrape(url) do
    IO.puts("scraping " <> url)
    {:ok, body} = get_body(url)

    {:ok, document} = Floki.parse_document(body)

    product = product_from_document(document, url)

    IO.puts("scraped " <> url)
    {:ok, product}
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
      url: url,
      price: price,
      title: title,
      image: image
    }
  rescue
    e ->
      %{
        url: url,
        price: nil,
        title: nil,
        image: nil
      }
  end
end
