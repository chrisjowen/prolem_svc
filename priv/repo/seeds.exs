# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     EventService.Repo.insert!(%EventService.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias EventService.Repo
alias EventService.Schema.{Event, Tag, EventTag}
# Faker.start()

# defmodule Foo do
#   import Ecto.Query
#   import Geo.PostGIS
#   alias EventService.Schema.Event

#   def example_query(geo, meters) do
#     query = from e in Event, limit: 5, where: st_distance(e.location, ^geo) < ^meters

#     query
#     |> Repo.all()
#   end

#   def generate_tags() do
#     [
#       "Live Music",
#       "Club",
#       "Happy Hour",
#       "Fitness",
#       "Show",
#       "Carnival",
#       "Drinks",
#       "Party"
#     ]
#     |> Enum.map(fn tag ->
#       Repo.insert!(%Tag{
#         name: tag,
#         type: "EVENT"
#       })
#     end)
#   end

#   def generate_events(tags) do
#     0..50
#     |> Enum.map(&generate_event(&1, tags))
#   end

#   def generate_event(i, tags) do
#     event =
#       Repo.insert!(%Event{
#         title: Faker.Company.name(),
#         start: ~N[2020-06-19 16:15:00],
#         end: ~N[2020-06-20 16:15:00],
#         location: %Geo.Point{coordinates: {30, -90}}
#       })

#     max = :rand.uniform(length(tags))

#     tags
#     |> Enum.take(max)
#     |> Enum.each(&add_tag_to_event(&1, event))
#   end

#   def add_tag_to_event(tag, event) do
#     Repo.insert!(%EventTag{
#       tag_id: tag.id,
#       event_id: event.id
#     })
#   end
# end

# Foo.generate_tags()
# Foo.generate_events(Foo.generate_tags()) |> IO.inspect

# Repo.all(Event) |> length() |> IO.inspect()

# Foo.example_query(geo, 500) |> IO.inspect

alias EventService.UserRepo

# UserRepo.insert_with_creds(
#   %{
#     "name" => "Mo",
#     "last_name" => "Bot",
#     "email" => "mohammedsp.me@gmail.com"
#   },
#   %{
#     "username" => "mo",
#     "password" => "letmein",
#     "salt" => "foo"
#   }
# ) |> IO.inspect


user = UserRepo.get_by(email: "mohammedsp.me@gmail.com")

{:ok, token, _claims} = EventService.Guardian.encode_and_sign(user)
IO.inspect("http://localhost:8080/callback/#{token}")
