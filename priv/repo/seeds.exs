defmodule Seeds do
  alias ProblemService.ProblemRepo

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
end


# Seeds.problems()
