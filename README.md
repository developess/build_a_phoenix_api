# Learn to build Elixir APIs 💻

This repo consists of 2 exercises to help you get to grips with servers in Elixir. The first is a shortened and themed version of the guide in the [Phoenix docs](https://hexdocs.pm/phoenix/up_and_running.html#content) and uses templates, while the second challenges you to finish a fun geography app called "🌏 Hello, World", by writing an API to serve data to a SPA front end.

## Exercise 1 - Your first REST API with Phoenix 🛌🦜

### 1a) Creating the app

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

`mix phx.new` creates a new Phoenix app in the umbrella.

The flags `--no-ecto` and `--no-webpack` reduce some of the boilerplate that comes with Phoenix, providing just the skeleton app for this example. Ecto is a database wrapper and webpack is for compiling front end code - we don't need this for now.

Select `Y` to fetch and install dependencies when prompted.

If dependencies don't install properly, you may not have a recent version of hex or Phoenix downloaded. Try running `mix local.hex` and installing deps again with `mix deps.get`. Still having issues? Check the [phoenix installation guide](https://hexdocs.pm/Phoenix/installation.html).

Now let's start this new Phoenix app using `mix phx.server`:

```
cd fawkes

mix phx.server
```

With your server up and running, check out the app at `localhost:4000`

If you can see a web page, then 🎉 you just made a server.

Now, lets dig into the code and work out how this app was created.

### 1b) Adding a new page

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

Here, `get` is our HTTP verb - a get request. `"/"` is the path, the url at which we're serving the resource. `PageController` is the name of a module in our controllers directory that returns the resource, and `:index` is the action - and corresponds to a function called index in the `PageController` controller.

Let's look inside the `controllers` directory in `page_controller.ex`. You'll see the index function that returns the resource:

```elixir
defmodule FawkesWeb.PageController do
  use FawkesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
```

How does this work? `conn` is short for `connection` - its actually a connection struct: `%Plug.Conn{}` - more on that later. You can think of it as equivalent to the request/response in other languages. `render` is a function afforded to us by the controller macro, which is imported at the top:

```elixir
use FawkesWeb, :controller
```

`render` takes `conn` as the first argument, and the response body as the second argument.

But where does `"index.html"` come from? Well, Phoenix is pretty smart and is set up to look in the `/templates` directory for the templates it renders. `index.html` matches the `index.html.eex` template we can see in the template folder, which you'll see matches the webpage you saw at `localhost:4000`

Now we understand _roughly_ how that page was served up, but there's still more to learn.

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

We're making a new template too. Let's make it super simple. Add a file to `/templates` called `magic.html.eex` and add the following code:

```html
<div class="phx-hero">
  <h2>Accio Brain!</h2>
</div>
```

Feel free to spice things up and insert your own favourite Harry Potter quote.

Pointing our browser to `http://localhost:4000/magic`, we should be able to see our own greeting from Phoenix! (if you stopped the server in an earlier step, you can restart it with `mix phx.server`).

**Quick aside: Whats this "eex" stuff?**

`.eex` files are Phoenix templates. EEx stands for Embedded Elixir. Phoenix templates are just that, templates into which data can be rendered.

We can interpolate values into our tempalates with syntax like the following:

```elixir
render(conn, "spell.html", spell_name: "Obliviate")
```

```html
<div class="phx-hero">
  <h2>Say good-bye to your memories! <%= @spell_name %>!</h2>
</div>
```

When we use the `render` function in the controller, we're optionally passing in values in as a [keyword list](https://elixir-lang.org/getting-started/keywords-and-maps.html), which in this case is `[spell_name: "Obliviate"]`. The square brackets aren't syntactically necessary, but are there invisibly. This is pasted into the template between the `<%=` and `%>` by using `@` followed by the varable name.

**Add one more route**

As a mini challenge, add a new route `/spell/:spell_name` where spell name is a url param. When passed into a function in a controller, this will come through as a [map](https://elixir-lang.org/getting-started/keywords-and-maps.html) like so:

```elixir
def index(conn, %{"spell_name" => spell_name}) do
  # Render a template here
end
```

Everything else you need to know to do this can be found in the eex section above!

Test its working by going to `localhost:4000/spell/lumos` to see your spell in the browser.

Sucess? Give yourself a pat on the back and make a cup of tea ☕️

### 1c) Examining our routes

Make sure you're in `apps/fawkes` and run the following command:

```
mix phx.routes
```

What can you see? Hopefully you can see a list of routes for your Phoenix app.

These are likely to all be GET routes as we're only adding those. When we declare our routes in `router.ex`, we can use all the usual HTTP verbs (`get`, `post`, `put` etc) but there are some other cool macros we can use too.

Go back to the `router.ex` file. Add the following route:

```elixir
resources "/spells", SpellController
```

Run `mix phx.routes` again. What can you see now?

You should be seeing a LOT more routes. The `resources` keyword automatically generates routes for the following 8 actions:

- `index` (GET)
- `show` (GET)
- `edit` (GET)
- `new` (GET)
- `create` (POST)
- `delete` (DELETE)
- `update` (PUT)
- `update` (PATCH)

For more information on what these actions are intended for, checkout the Phoenix routing guide [here](https://hexdocs.pm/phoenix/routing.html#resources)

If you didn't want all 8 of these routes in your api, you can exclude some like so:

```elixir
resources "/comments", CommentController, except: [:delete]
```

Or you can just specify the routes you want:

```elixir
resources "/posts", PostController, only: [:index, :show]
```

**Note:**

So far in examples I've been using `:index` as the controller action, e.g.

```elixir
get "/magic", MagicController, :index
```

However, you're not limited to `index`, or any other keywords like `show` or `create`. Its just convention to use `:index` for a page, for example.

In an API with loads of routes to the same controller, other words (i.e. function names) might be more appropriate, e.g.

```elixir
get "/subject/:subject", HogwartsController, :subject_info
```

### 1d) Scoping

Lets go back to our `router.ex` file and see what's going on with the `scope` keywords.

For example, we've been putting our routes in this section:

```elixir
  scope "/", FawkesWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/magic", MagicController, :index
    get "/spell/:spell_name", SpellController, :index
  end
```

A scope is a way of grouping routes. All our routes are scoped under the home (`"/"`) route, but we could make another scope under an admin route, for example.

```elixir
  scope "/admin", FawkesWeb do
    pipe_through :browser
    pipe_through :authentication

    get "/spells", PageController, :index
    get "/magic", PageController, :index
  end
```

This would make 2 new routes available, at: `/admin/spells` and `/admin/magic`.

Why would we want to do that? The answer lies in the `pipe_through` functions at the top of each scope. These `pipe_through` functions require requests to be passed through certain `pipelines` before being routed to the relevant controller. These pipelines consist of a series of `plugs`, which are special functions or modules, that are equivalent to 'middlewares'.

In our boilerplate code we have two pipeline types:

```elixir
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
```

I won't go into the details of each plug (their names are pretty self-explanatory), but these pipelines nicely encapsulate repeated tasks like adding headers or specifying content-types.

By creating an `/admin` scope, we could add an authentication pipeline that forces users to be authenticated to access certain pages. Pretty cool!

We can even nest scopes within scopes, to create versioned APIs. For example:

```elixir
scope "/api", HelloWeb.Api, as: :api do
  pipe_through :api

  scope "/v1", V1, as: :v1 do
    resources "/spells",  ImageController
    resources "/subjects", ReviewController
    resources "/creatures",   UserController
  end
end
```

Creates routes like so:

- `api/v1/spells`
- `api/v1/subjects`
- `api/v1/creatures`

Note, routes don't **have** to sit inside a scope, and plugs don't **have** to sit inside pipelines. If you had a simple server that treated all requests the same, you could have a few plug middlewares followed by a few lone routes, and requests would run top-to-bottom through the plugs before finding their route. However, by doing so you'd be missing out on the neat router modularisation that Phoenix offers.

### 1e) Hol' up, whats exactly is a plug?

Are you ready to have your mind blown a little bit? Plugs live at the heart of Phoenix's HTTP layer. We've been interacting with plugs throughout this tutorial - they're at every step of the connection lifecycle, and the core Phoenix components like Endpoints, Routers, and Controllers are all just Plugs internally 😱

Plugs aren't something created by Phoenix - they're a thing used by Phoenix, and can be used outside Phoenix when dealing with HTTP in elixir more generally. Remember, Phoenix isn't the only way to make a web server in elixir, just like Express isn't the only way to make a server in Node.js.

[`Plug`](https://hexdocs.pm/phoenix/plug.html#content) the specification describes itself as 'a specification for composable modules in between web applications'.

The basic idea of Plug is to unify the concept of a "connection" that we operate on. This differs from other HTTP middleware layers (e.g. Rack), where the request and response are separated in the middleware stack.

There are 2 main types of plug: `Function plugs` and `Module plugs`

**Function Plugs**

In order to act as a plug, a function simply needs to accept a connection struct (`%Plug.Conn{}`) and options. It also needs to return a connection struct.

Here's an example. It simply converts a `key_values` list to response headers, and adds them to the response.

```elixir
def put_headers(conn, key_values) do
  Enum.reduce key_values, conn, fn {k, v}, conn ->
    Plug.Conn.put_resp_header(conn, to_string(k), v)
  end
end
```

We could use this plug in a pipeline like so:

```elixir
 pipeline :api do
    plug :accepts, ["json"]
    plug :put_headers, %{content_encoding: "gzip", cache_control: "max-age=3600"}
  end
```

**Module plugs**

Module plugs are another type of Plug that let us define a connection transformation in a module. The module only needs to implement two functions:

- `init/1` which initializes any arguments or options to be passed to `call/2`
- `call/2` which carries out the connection transformation. `call/2` is just a function plug like what you see above.

You use a module plug like so:

```elixir
plug MyWebApp.Plugs.Locale, "en"
```

For more info on module plugs, and plugs in general read on [here](https://hexdocs.pm/phoenix/plug.html#module-plugs).

### 1f) Returning different stuff, redirecting and error codes

So far we've just rendered templates. What if we want to build an API that returns json, or text?

The answer is suprisingly simple. Remember our `render` function in our controller earlier?

```elixir
defmodule FawkesWeb.MagicController do
  use FawkesWeb, :controller

  def index(conn, _params) do
    render(conn, "magic.html")
  end
end
```

Well, `render` isn't our only option here.

We can return plain text with the `text` function like so:

```elixir
text(conn, "It does not do to dwell on dreams and forget to live.")
```

or json with the `json` function like this:

```elixir
json(conn, %{"spell" => %{"name" => "Imperius Curse", "incantation" => "Imperio"}})
```

When using `json()`, you should pass in a map with string keys. Phoenix ships with a json encoder/decoder package called `Jason` that takes care of encoding that map to json. Win!

**What if I want to return a 404, or a redirect?**

[`Phoenix.Controller`](https://hexdocs.pm/phoenix/Phoenix.Controller.html#content) offers several functions including `redirect` out the box:

```elixir
redirect(conn, to: "/login")
```

However, we might want something a bit more home-grown. Because the `conn` argument is a `%Plug.Conn` struct, we can go to the `Plug` documentation and find some more fundamental functions, like `send_resp` for sending responses. Check out some of our options [here](https://hexdocs.pm/plug/Plug.Conn.html).

Phoenix abstracts away a lot of these functions for us, by creating controller macros like `json()`. This is good and bad. It makes things easy, but sometimes we can't find the thing we need or we don't see how things are really working 'under the hood'. We can get back to basics with code like this:

```elixir
send_resp(conn, 404, "Much like the room of requirement, this web page is not found\n")
```

## You made it to the end! 🎉🔥

Congrats on making it through this exercise. Don't worry, the next one is much less text-heavy and more hands on!

I hope this helped you get to grips with Phoenix, and you are beginning to understand the power and flexibility of web server programming in Elixir!

**Part deux**

You should see a directory called `hello_world` inside your `apps` folder. Navigate to the README in there to find your next challenge. Or go to the github web page [here](https://github.com/developess/build_a_phoenix_api/blob/master/apps/hello_world/README.md)

...After a deserved break from your screen, and maybe a cookie 🍪
