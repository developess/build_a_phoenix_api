defmodule HelloWorldWeb.CountryController do
  use HelloWorldWeb, :controller

  alias HelloWorldWeb.CountriesData

  def test(conn, _params) do
    text(conn, "Hello, world")
  end

  # Part 1:
  # Implement new controller actions here
  # Hint: use the functions in data_helpers/countries.ex!
  def index(conn, _params) do
    json(conn, %{"countries" => CountriesData.get_all_countries()})
  end

  def show(conn, %{"name" => name}) do
    json(conn, %{"country" => CountriesData.get_country_by_name(name)})
  end
end
