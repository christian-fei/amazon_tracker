defmodule AmazonTracker.Amazon.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :title, :string
    field :url, :string
    field :image, :string

    has_many :prices, AmazonTracker.Amazon.Price

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :url, :image])
    |> validate_required([:title, :url, :image])
  end
end
