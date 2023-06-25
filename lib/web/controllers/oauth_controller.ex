defmodule ProblemService.OAuthController do
  use ProblemService.Web, :controller
  alias ProblemService.Repo
  alias ProblemService.Schema.User

  plug Ueberauth

  @auth %Ueberauth.Auth{
    uid: "113915443239029386551",
    provider: :google,
    strategy: Ueberauth.Strategy.Google,
    info: %Ueberauth.Auth.Info{
      name: "Chris Owen",
      first_name: "Chris",
      last_name: "Owen",
      nickname: nil,
      email: "chrisjowen286@gmail.com",
      location: nil,
      description: nil,
      image:
        "https://lh3.googleusercontent.com/a/AAcHTteOBiGJFOTDGNJjM-SO-hnQAXTDKNZLqYFu7uqa=s96-c",
      phone: nil,
      birthday: nil,
      urls: %{profile: nil, website: nil}
    },
    credentials: %Ueberauth.Auth.Credentials{
      token:
        "ya29.a0AWY7Ckm5iRLVOAP9Bn7U2re8PyXVuewKwp8xzQ-8mvfi_-0lwXIzuEPs5pSHs9IRsimrnyRul2zfFmptoBzLTsPfFfGhzTaOpHfLGWXBaTWDqB1WRKturwyiA7WBmB90s4hw8ZoMsRuII-H2jETYKIrCursn8gaCgYKAe0SARESFQG1tDrp2stvyl6urDpc_dLmfEH1gA0165",
      refresh_token: nil,
      token_type: "Bearer",
      secret: nil,
      expires: true,
      expires_at: 1_687_625_912,
      scopes: [
        "https://www.googleapis.com/auth/userinfo.email openid https://www.googleapis.com/auth/userinfo.profile"
      ],
      other: %{}
    },
    extra: %Ueberauth.Auth.Extra{
      raw_info: %{
        token: %OAuth2.AccessToken{
          access_token:
            "ya29.a0AWY7Ckm5iRLVOAP9Bn7U2re8PyXVuewKwp8xzQ-8mvfi_-0lwXIzuEPs5pSHs9IRsimrnyRul2zfFmptoBzLTsPfFfGhzTaOpHfLGWXBaTWDqB1WRKturwyiA7WBmB90s4hw8ZoMsRuII-H2jETYKIrCursn8gaCgYKAe0SARESFQG1tDrp2stvyl6urDpc_dLmfEH1gA0165",
          refresh_token: nil,
          expires_at: 1_687_625_912,
          token_type: "Bearer",
          other_params: %{
            "id_token" =>
              "eyJhbGciOiJSUzI1NiIsImtpZCI6Ijk5YmNiMDY5MzQwYTNmMTQ3NDYyNzk0ZGZlZmE3NWU3OTk2MTM2MzQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTI5ODAwNjEzNDUtazhhNWlsbGNsM2ZocmFiMDhpMnRvdmFraGU4Y3R1YnEuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTI5ODAwNjEzNDUtazhhNWlsbGNsM2ZocmFiMDhpMnRvdmFraGU4Y3R1YnEuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTM5MTU0NDMyMzkwMjkzODY1NTEiLCJlbWFpbCI6ImNocmlzam93ZW4yODZAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiI4bTQ3ZmplaDJyWnFvVkJYZkRYUF9RIiwibmFtZSI6IkNocmlzIE93ZW4iLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUFjSFR0ZU9CaUdKRk9UREdOSmpNLVNPLWhuUUFYVERLTlpMcVlGdTd1cWE9czk2LWMiLCJnaXZlbl9uYW1lIjoiQ2hyaXMiLCJmYW1pbHlfbmFtZSI6Ik93ZW4iLCJsb2NhbGUiOiJlbi1HQiIsImlhdCI6MTY4NzYyMjMxMywiZXhwIjoxNjg3NjI1OTEzfQ.CFWN6-EF-EYcUk8a-694JsjejR6Q56Rd38etB21GXfHigvZi1gW1JzhoLF76An7jtn_lRinxzF0nR8q_0u4hyrAvHMc2phcIMn1E7nkcUOqNisywz5b9Xx7rsEgitJRIOEpdOFuoc6KeS4IrCw9VkVvoZgyC1jwiaodDgkTSLSBAW-7cPkxVKtaCqJ_HYKOL0e9NmokPQ9UnfZSBUH-tXCyE0sSqoNPSLFXtfAB3j7UnxStsMp1BTeeufd17m5MiJGirYSXg5g9mBFYFNC9bWy6Q_7dngv9c23OVq_PGwEI5sah1pkMhM03CL8mHiRtRm0WQYKZVvl20NL1TBNKJ9A",
            "scope" =>
              "https://www.googleapis.com/auth/userinfo.email openid https://www.googleapis.com/auth/userinfo.profile"
          }
        },
        user: %{
          "email" => "chrisjowen286@gmail.com",
          "email_verified" => true,
          "family_name" => "Owen",
          "given_name" => "Chris",
          "locale" => "en-GB",
          "name" => "Chris Owen",
          "picture" =>
            "https://lh3.googleusercontent.com/a/AAcHTteOBiGJFOTDGNJjM-SO-hnQAXTDKNZLqYFu7uqa=s96-c",
          "sub" => "113915443239029386551"
        }
      }
    }
  }

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> redirect(external: System.get_env("UI_BASE_URL"))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user =
      case Repo.get_by(User, ext_id: auth.uid, ext_ref: "google") do
        nil -> get_or_create_user(auth)
        user -> user
      end

    IO.inspect(user)
    {:ok, token, _} = user |> ProblemService.Guardian.encode_and_sign() |> IO.inspect()

    conn
    |> redirect(external: System.get_env("UI_BASE_URL") <> "/login/cb/#{token}")
  end

  defp get_or_create_user(auth = %Ueberauth.Auth{}) do
    case Repo.get_by(User, email: auth.info.email) do
      nil -> create_user(auth)
      user -> maybe_update_user_ext_id(user, auth)
    end
  end

  defp create_user(auth = %Ueberauth.Auth{}) do
    username = auth.info.name |> String.downcase() |> String.replace(" ", "_")

    User.changeset(%User{}, %{
      "username" => username,
      "name" => auth.info.first_name,
      "last_name" => auth.info.last_name,
      "email" => auth.info.email,
      "ext_id" => auth.uid,
      "ext_ref" => Atom.to_string(auth.provider)
    })
    |> Repo.insert!()
  end

  defp maybe_update_user_ext_id(user, auth = %Ueberauth.Auth{}) do
    case user.ext_id do
      nil ->
        User.changeset(user, %{ext_id: auth.uid, ext_ref: "google"})
        |> Repo.update!()

      _ ->
        user
    end
  end
end
