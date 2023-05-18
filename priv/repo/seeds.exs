defmodule Seeds do
  alias ProblemService.ProblemRepo
  alias ProblemService.UserRepo

  def problems do
    [
      %{
        title: "Problems Worth Solving",
        slug: "problem_worth_solving",
        blurb: "Bring the pool of development talent together to solve interesting problems",
        overview: "Bring the pool of development talent together to solve interesting problems",
        img: "https://source.unsplash.com/random/1280x540?idea"
      },
      %{
        title: "AI Automation Testing & Usability Checking",
        slug: "ai_usabiity_testing",
        blurb: "Use ChatGPT or equivillent to drive automation testing",
        overview: "Use ChatGPT or equivillent to drive automation testing",
        img: "https://source.unsplash.com/random/1280x540?test"
      },
      %{
        title: "Hack Yourself",
        slug: "hack_yourself",
        blurb: "Use the online signals we generate for our own good, not advertising",
        overview: "Use the online signals we generate for our own good, not advertising",
        img: "https://source.unsplash.com/random/1280x540?hack"
      },
      %{
        title: "Codified best practice architectures",
        slug: "codified_best_practice",
        blurb: "Best practice architectures on real working applications, easily customizable",
        overview: "Best practice architectures on real working applications, easily customizable",
        img: "https://source.unsplash.com/random/1280x540?brain"
      },
      %{
        title: "Idea for autism",
        slug: "autism_nice",
        blurb: "Best practice architectures on real working applications, easily customizable",
        overview: "Best practice architectures on real working applications, easily customizable",
        img: "https://source.unsplash.com/random/1280x540?smile"
      }
    ]
    |> Enum.each(&ProblemRepo.insert!/1)
  end

  def users do
    users =
      [
        # %{
        #   "name" => "Christopher",
        #   "last_name" => "Owen",
        #   "email" => "chris.j.owen@hotmail.co.uk",
        #   "password" => "letmein123"
        # }
        %{
          "name" => "Jame",
          "last_name" => "Brown",
          "email" => "jamesbrown@hotmail.co.uk",
          "password" => "letmein123"
        }
      ]
      |> Enum.map(&UserRepo.insert!/1)
      |> IO.inspect()
  end
end

Seeds.users()
