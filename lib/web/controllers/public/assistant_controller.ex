defmodule ProblemService.Public.AssistantController do
  use ProblemService.BaseController
  alias ProblemService.ProblemRepo

  def improvements(conn, %{ "problem" =>  problem}) do
    conn |> json(Openai.Advice.generate(problem))
  end

  def similar(conn, %{ "problem" =>  problem}) do
    conn |> json(Openai.Research.similar_products(problem))
  end

  def features(conn, %{ "problem" =>  problem}) do
    conn |> json(Openai.Research.features(problem))
  end

  def solution(conn, %{ "problem" =>  problem}) do
    conn |> json(Openai.Research.solution(problem))
  end
  def actors(conn, %{ "problem" =>  problem}) do
    conn |> json(Openai.Persona.Actors.generate(problem))
  end

  def persona(conn, params) do
    conn |> json(Openai.Persona.generate(params))
  end

  def avatar(conn, params) do
    conn |> json(Openai.Persona.Avatar.generate(params) )
  end

  def statement(conn, %{ "problem" =>  problem}) do
    conn |> json(Openai.Statement.generate(problem) )
  end

end
