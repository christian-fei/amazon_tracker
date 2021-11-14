defmodule AmazonTracker.Amazon.Price do
  use Ecto.Schema
  import Ecto.Changeset

  schema "prices" do
    field :price, :float

    belongs_to :product, AmazonTracker.Amazon.Product

    timestamps()
  end

  @doc false
  def changeset(price, attrs) do
    price
    |> cast(attrs, [:price, :product_id])
    |> validate_required([:price, :product_id])
  end
end
