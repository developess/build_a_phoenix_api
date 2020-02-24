# Elixir Api Exercise

## Exercise 1 - Playing with the Phoenix defaults

### 1a Creating the app

We're going to start by creating a new Phoenix app in this umbrella application and understanding all the awesome boilerplate that comes with it.

Start by cloning this repo, and navigating to the root.

```
git clone https://github.com/developess/build_a_phoenix_api.git

cd build_a_phoenix_api
```

Since this is an umbrella application, we want to move to the `apps` folder to create a new app under the umbrella. I'm calling my app `fawkes` because this is a throwaway app and it will stand out when we're looking around (plus he's the OG phoenix). **Don't** name your app something generic that you may see in code like 'Test' or 'Elixir' as you'll just confuse yourself!

From the project root, run:

```
cd apps

mix phx.new fawkes --no-ecto --no-webpack
```

`mix phx.new` creates a new phoenix app in the umbrella.

The flags `--no-ecto` and `--no-webpack` reduce some of the boilerplate that comes with phoenix, providing just the skeleton app for this example. Ecto is a database wrapper and webpack is for compiling front end code - we don't need this for now.

Select `Y` to fetch and install dependencies when prompted.

If dependencies don't install properly, you may not have a recent version of hex or phoenix downloaded. Try running `mix local.hex` and installing deps again with `mix deps.get`. Still having issues? Check the [phoenix installation guide](https://hexdocs.pm/phoenix/installation.html).

Now let's start this new phoenix app using `mix phx.server`:

```
cd fawkes

mix phx.server
```

With your server up and running, check out the app at `localhost:4000`

If you can see a web page, then 🎉 you just made a server.

Now, lets dig into the code and work out how this app was created.

### 1b Adding a new page

Your newly created file structure (in `apps/fawkes`) should look something like the below. The key folder here is the `lib` folder, which holds your application files (equivalent of `src` in other languages).

Inside `lib` should be 2 more folders: `fawkes` and `fawkes_web`. We're interested in `fawkes_web` as that holds the majority of the setup files for the web server. `fawkes` just holds an application file which starts the server in a process.

```
├── config
├── lib
│   └── fawkes
│   └── fawkes_web
│   └── fawkes.ex
│   └── fawkes_web.ex
├── priv
├── test
├── ...
```

Inside `fawkes_web` our file structure looks like this:

```
├── channels
│ └── user_socket.ex
├── controllers
│ └── page_controller.ex
├── templates
│ ├── layout
│ │ └── app.html.eex
│ └── page
│ └── index.html.eex
└── views
│ ├── error_helpers.ex
│ ├── error_view.ex
│ ├── layout_view.ex
│ └── page_view.ex
├── endpoint.ex
├── gettext.ex
├── router.ex

```

As you might recognise, Phoenix has set up a classic "MVC" (Model, View, Controller) pattern for us. I won't dive into the merits of this pattern here, but it provides a useful scaffold to make sense of all these files!

Open up `router.ex`. The router is often the heart of a web server and is a useful place to start.

```elixir
defmodule FawkesWeb.Router do
  use FawkesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FawkesWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", FawkesWeb do
  #   pipe_through :api
  # end
end
```

Routes map unique HTTP verb/path pairs to controller/action pairs which will handle them. The page that you saw when you opened up `localhost:4000` is created by this line:

```elixir
get "/", PageController, :index
```

Here, `get` is our HTTP verb - a get request. `"/"` is the path, the url at which we're serving the resouce. `PageController` is the name of a module in our controllers directory that returns the resource, and `:index` is the action - and corresponds to a function called index in the `PageController` controller.

Let's look inside the `controllers` directory in `page_controller.ex`. You'll see the index function that returns the resource:

```elixir
defmodule FawkesWeb.PageController do
  use FawkesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
```

How does this work? `conn` is short for `connection` - its kind of equivalent to the `(req, res)` you might get in node. `render` is a function afforded to us by the controller macro, which is imported at the top:

```elixir
use FawkesWeb, :controller
```

But where does `"index.html"` come from? Well, Phoenix is pretty smart and is set up to look in the `/templates` directory for the templates it renders. `index.html` matches the `index.html.eex` template we can see in the template folder, which you'll see matches the webpage you saw at `localhost:4000`

Now we understand _roughly_ how.

**Let's add a new page to the app**

In `router.ex` add a new route.

```elixir
get "/magic", MagicController, :index
```

Since we're using a new controller, let's create a new file in the `controllers` directory.

```elixir
defmodule FawkesWeb.MagicController do
  use FawkesWeb, :controller

  def index(conn, _params) do
    render(conn, "magic.html")
  end
end
```