defmodule ProblemService.Experts.ExpertFinderClient do
  use ProblemService.DataCase
  alias ProblemService.Clients.Experts.ExpertFinderClient

  # @tag :integration
  # test "Can fetch expert categories" do
  #   {:ok, categories} = ExpertFinderClient.categories() |> IO.inspect
  #   assert length(categories) > 0
  # end

  # @tag :integration
  # test "Can fetch expert profiles " do
  #   {:ok, profiles} = ExpertFinderClient.experts("air-quality-experts") |> IO.inspect
  #   assert length(profiles) > 0
  # end

   @tag :integration
  test "Can fetch  profiles " do
    ExpertFinderClient.expert("karen-bartlett") |> IO.inspect
    # assert length(profiles) > 0
  end


  # https://expertisefinder.com/find-an-expert/young-experts/

  # https://expertisefinder.com/find-an-expert/
end
