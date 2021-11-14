defmodule AmazonTracker.Repo.Migrations.CreatePrices do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :price, :float

      timestamps()
    end
  end
end
