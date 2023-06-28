defmodule ProblemService.AiController do
  use ProblemService.Web, :controller

  def imagery(conn, %{"content" => content}) do
    with {:ok, result} <- Ai.ImageryGenerator.execute(content),
         {:ok, image} <-
           Ai.ImageGenerator.execute(
             "A serious digital image: #{result["imagery"]}. NO FONTS OR TEXT. ONLY IMAGES!!!"
           ) do
      json(conn, image)
    end

  end


  def sector(conn, %{"sector" => sector}) do
    {:ok, result}  = Ai.SectorDescriptionGenerator.execute(sector)

    json(conn, result)
  end


  def stakeholder(conn, %{"idea" => idea, "problem" => problem}) do
    {:ok, result}  = Ai.StakeholderGenerator.execute(idea,problem)

    json(conn, result)
  end

  def stakeholder_describe(conn, %{"stakeholder" => stakeholder}) do
    {:ok, result}  = Ai.StakeholderImageGenerator.execute(stakeholder)
    json(conn, result)
  end

end
