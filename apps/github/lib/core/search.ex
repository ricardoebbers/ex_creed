defmodule Github.Core.Search do
  use Tesla

  @base_url "https://api.github.com/search"

  def repositories(query) do
    client()
    |> Tesla.get("/repositories", query: parse_query(query))
  end

  defp parse_query(_query) do
    [q: "language:elixir", sort: "stars", order: "desc", page: 1, per_page: 100]
  end

  defp client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, @base_url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"Accept", "application/vnd.github.v3+json"}]}
    ]

    Tesla.client(middleware)
  end
end
