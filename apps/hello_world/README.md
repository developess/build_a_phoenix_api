# 🌏 Hello, World

Welcome to exercise 2!

This is a short exercise where you'll use what you've learnt about APIs to deliver data to our front end website, Hello World.

First, lets get this server up and running. From inside this app:

- Install dependencies with `mix deps.get`
- Start Phoenix endpoint with `mix phx.server`
- Visit [`localhost:4000/test`](http://localhost:4000/test) from your browser.

You should be able to see the text "Hello, World", which is from a test route we've implemented for you in `router.ex`.

## The frontend

This exercise comes with a React front end, held in a separate repository - [here](https://github.com/developess/countries_of_the_world_react_app).

Go to that repo, clone and start the app, to see what you're working with.

## Your task

You'll notice there are 2 pages in the app - `CountryList` and `CountryPage` - which make API calls using `axios`. These pages currently aren't working, because the routes they call don't exist!

To make these requests work, you need to create **2 new endpoints** in your elixir code to deliver the necessary data.

Please note, you DO NOT need to change the javascript app! Try and make your app work without changing the front end.

Good Luck! ✈️
