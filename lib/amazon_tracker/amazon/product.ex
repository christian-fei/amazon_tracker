defmodule AmazonTracker.Amazon.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :price, :string
    field :title, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :url, :price])
    |> validate_required([:title, :url, :price])
  end
end
