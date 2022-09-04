# alias Totem.GroupTypeRepo

# groups =
#   [
#     "Drinks",
#     "Food",
#     "Sight Seeing",
#     "Cinema",
#     "Show",
#     "Excersise"
#   ]
#   |> Enum.each(&GroupTypeRepo.create(%{name: &1}))
alias Totem.UserRepo

# user = UserRepo.insert_with_creds(
#   %{
#     "name" => "Vivien",
#     "last_name" => "Koh",
#     "email" => "kohvvn@gmail.com"
#   },
#   %{
#     "username" => "viv",
#     "password" => "test",
#     "salt" => "Nonsense"
#   }
# ) |> IO.inspect()


user = UserRepo.insert_with_creds(
  %{
    "name" => "Mo",
    "last_name" => "Man",
    "email" => "mohammedsp.me@gmail.com"
  },
  %{
    "username" => "Mo",
    "password" => "moman",
    "salt" => "Nonsense"
  }
) |> IO.inspect()



user = UserRepo.get_by(email:  "mohammedsp.me@gmail.com") |> IO.inspect

{:ok, token, _claims} = Totem.Guardian.encode_and_sign(user)
IO.inspect("http://localhost:8080/callback/#{token}")
