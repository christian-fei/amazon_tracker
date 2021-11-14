defmodule AmazonTracker.Repo.Migrations.PriceBelongsToProduct do
  use Ecto.Migration

  def change do
    alter table(:prices) do
      add :product_id, references(:products)
    end
  end
end
