defmodule AmazonTracker.AmazonFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AmazonTracker.Amazon` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        title: "some title",
        url: "some url",
        price: 123.45,
        image: "some-image"
      })
      |> AmazonTracker.Amazon.create_product()

    product
  end
end
