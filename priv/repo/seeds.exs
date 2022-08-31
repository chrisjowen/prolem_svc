alias Totem.GroupTypeRepo

groups = [
  "Drinks",
  "Food",
  "Sight Seeing",
  "Cinema",
  "Show",
  "Excersise"
] |>  Enum.each(&(GroupTypeRepo.create(%{ name: &1})))



# # {:ok, token, _claims} = Totem.Guardian.encode_and_sign(user)
# # IO.inspect("http://localhost:8080/callback/#{token}")
