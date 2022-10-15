alias Totem.GroupTypeRepo
alias Totem.UserRepo
alias Totem.EventRepo
alias Totem.GroupTypeRepo
alias Totem.EventTypeRepo


# user = UserRepo.get_by(email:  "mohammedsp.me@gmail.com") |> IO.inspect

# {:ok, token, _claims} = Totem.Guardian.encode_and_sign(user)
# IO.inspect("http://localhost:8080/callback/#{token}")


defmodule Seed do
  def group_types() do
    [
      "Drinks",
      "Food",
      "Sight Seeing",
      "Cinema",
      "Show",
      "Excersise"
    ]
    |> Enum.each(&GroupTypeRepo.insert!(%{name: &1}))
  end








  def event_types() do
    [
      "Arts and Culture",
      "Food & Drinks",
      "Festival/Cmiarnival",
      "Sports and Fitness",
      "Music and Nightlife",
      "Workshops",
      "Show",
      "Shopping",
      "Pop-up",
      "Kids",
      "Other"
    ]
    |> Enum.each(&EventTypeRepo.insert!(%{name: &1}))
  end

  def users() do
    UserRepo.insert_with_creds(
      %{
        "name" => "Vivien",
        "last_name" => "Koh",
        "email" => "kohvvn@gmail.com"
      },
      %{
        "username" => "viv",
        "password" => "test",
        "salt" => "Nonsense"
      }
    )

    UserRepo.insert_with_creds(
      %{
        "name" => "Mo",
        "last_name" => "Man",
        "email" => "mohammedsp.me@gmail.com"
      },
      %{
        "username" => "mo",
        "password" => "test",
        "salt" => "Nonsense"
      }
    )
  end

  def events do
    point = %Geo.Point{coordinates: {103.84631, 1.2901908}}
    %{
      "title" => "My Awesome Event",
      "description" => "Some description of the event this can be large",
      "location" => point,
      "place_id" => "ChIJxcECHaAZ2jERfOrtQ1ZT0Oc",
      "start" => ~N[2022-09-30 23:00:07],
      "end" => ~N[2022-09-30 23:00:07]
    }
    |> EventRepo.insert!()

  end

end


Seed.group_types()
Seed.event_types()
