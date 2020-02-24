defmodule HelloWorldWeb.CountriesData do
  @doc """
  Helper functions to retrieve a country data.

  You do NOT need to edit these functions for the exercises.

  Aside: we're using a csv here to avoid the hassle of a database while
  learning about APIs. Don't do this in real life.
  """

  @data_path Path.expand('./lib/hello_world_web/data_helpers/countries.csv')

  @doc """
  Retrieves a list of all countries and their associated data
  """
  def get_all_countries do
    @data_path
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.map(&atomize_keys/1)
  end

  @doc """
  Retrieves a country and its data by country name (case insensitive)
  """
  def get_country_by_name(name) do
    @data_path
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.find(fn %{"Country" => found_name} ->
      String.downcase(found_name) == String.downcase(name)
    end)
  end

  defp atomize_keys(map) when is_map(map) do
    for {k, v} <- map, do: {k, v}, into: %{}
  end
end
