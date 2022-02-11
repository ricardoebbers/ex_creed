defmodule Github.Core.Query do
  alias __MODULE__

  @type t :: %__MODULE__{
          q: String.t(),
          sort: String.t(),
          order: String.t(),
          per_page: pos_integer(),
          page: pos_integer()
        }

  defstruct q: "language:elixir",
            sort: "stars",
            order: "desc",
            per_page: 100,
            page: 1

  def new() do
    %Query{}
  end

  def limit(query, limit) do
    %{query | per_page: limit}
  end

  def updated_last_twelve_months(query) do
    twelve_months_ago =
      Date.utc_today()
      |> Date.add(-365)
      |> Date.beginning_of_month()
      |> Date.to_string()

    Map.update(query, :q, query.q, fn current ->
      "#{current} pushed:>#{twelve_months_ago}"
    end)
  end

  def is_public(query) do
    Map.update(query, :q, query.q, fn current -> "#{current} is:public" end)
  end

  def not_archived(query) do
    Map.update(query, :q, query.q, fn current -> "#{current} archived:false" end)
  end
end
