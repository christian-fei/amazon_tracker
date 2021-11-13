defmodule AmazonTracker.Repo do
  use Ecto.Repo,
    otp_app: :amazon_tracker,
    adapter: Ecto.Adapters.Postgres
end
