defmodule AmazonTracker.Repo.Migrations.AddImageFieldToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :image, :string
    end
  end
end
