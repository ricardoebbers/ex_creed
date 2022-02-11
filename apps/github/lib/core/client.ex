defmodule Github.Core.Client do
  use Tesla

  require Logger
  @base_url "https://api.github.com/search"

  def repositories(query) do
    client()
    |> Tesla.get("/repositories", query: parse_query(query))
    |> case do
      {:ok, %{body: %{"incomplete_results" => true}}} ->
        {:error, :incomplete_results}

      {:ok, %{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %{status: status, body: body, query: query}} ->
        {:error, %{status: status, body: body, query: query}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp parse_query(query) do
    query
    |> Map.from_struct()
    |> Enum.map(&Function.identity/1)
  end

  defp client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, @base_url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"Accept", "application/vnd.github.v3+json"}]},
      Tesla.Middleware.Logger
    ]

    Tesla.client(middleware)
  end
end
