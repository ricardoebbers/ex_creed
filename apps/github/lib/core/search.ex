defmodule Github.Core.Search do
  alias Github.Core.Client
  alias Github.Core.Query

  def run() do
    build_query()
    |> Client.repositories()
  end

  def count() do
    build_query()
    |> Query.limit(1)
    |> Client.repositories()
    |> case do
      {:ok, body} -> body["total_count"]
    end
  end

  defp build_query() do
    Query.new()
    |> Query.not_archived()
    |> Query.is_public()
    |> Query.updated_last_twelve_months()
  end
end
