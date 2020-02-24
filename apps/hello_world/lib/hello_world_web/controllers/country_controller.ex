defmodule HelloWorldWeb.CountryController do
  use HelloWorldWeb, :controller

  alias HelloWorldWeb.CountriesData

  def test(conn, _params) do
    text(conn, "Hello, world")
  end

  # Implement new controller actions here
  # Hint: use the functions in data_helpers/countries.ex!
end
