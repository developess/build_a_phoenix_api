defmodule HelloWorldWeb.CountryController do
  use HelloWorldWeb, :controller

  alias HelloWorldWeb.CountriesData

  def test(conn, _params) do
    text(conn, "Hello, world")
  end

  # Implement new controller actions here
  # Hint: use the functions in data_helpers/countries.ex!
  def all_countries(conn, _params) do
    json(conn, Jason.encode!(%{countries: CountriesData.get_all_countries()}))
  end

  def country(conn, %{"name" => name}) do
    json(conn, Jason.encode!(%{country: CountriesData.get_country_by_name(name)}))
  end
end
