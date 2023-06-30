alias ProblemService.Schema.Problem
alias ProblemService.Schema.Obstacle
alias ProblemService.Repo

defmodule Seeder do
  @liveUrl "https://www.crowdsolve.ai"
  @devUrl "http://localhost:4000"

  def execute() do

    dev_sectors = HTTPoison.get!("#{@devUrl}/api/sector?page_size=1000").body
    |> Jason.decode!()

    live_sectors = HTTPoison.get!("#{@liveUrl}/api/sector?page_size=1000").body
    |> IO.inspect()
    |> Jason.decode!()


    dev_names = dev_sectors["entries"] |> Enum.map(&(&1["name"]))
    live_names = live_sectors["entries"] |> Enum.map(&(&1["name"]))


    """
    Robotics Process Automation (RPA)
    Big Data Analytics
    Data Science
    Cloud Computing
    Mobile App Development
    E-commerce
    Software as a Service (SaaS)
    Cyber-Physical Systems
    Internet of Vehicles (IoV)
    Natural Language Processing (NLP)
    Computer Vision
    Robotics Perception
    Human-Computer Interaction (HCI)
    Augmented Reality (AR) in non-marketing applications
    Virtual Reality (VR) in non-gaming applications
    Quantum Cryptography
    Quantum Networking
    Virtual Assistants
    Chatbot Development
    Data Visualization
    Image Recognition
    Speech Recognition
    Autonomous Vehicles
    Computer Graphics and Animation
    E-learning Platforms
    Cloud Storage and Backup
    Network Security
    Robotics Process Outsourcing (RPO)
    Industrial Automation
    Humanoid Robots
    Intelligent Systems in Manufacturing
    Robotics in Agriculture
    Smart City Solutions
    Financial Analytics
    Supply Chain Optimization
    IT Consulting and Services
    Telecommunications Infrastructure
    Enterprise Resource Planning (ERP) Systems
    Video Streaming Technology
    Social Media Analytics
    """
    |> String.split("\n")
    |> Enum.filter(fn name -> !Enum.member?(dev_names, name) or name == "" end)
    |> Enum.uniq()
    |> Enum.each(&generate_resources/1)

    Enum.join(dev_names, "\n") |> IO.inspect()

  end
  def generate_resources(sector) do
    Task.async(fn ->

      token =
        "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJwcm9ibGVtX3NlcnZpY2UiLCJleHAiOjE2OTA0NTU1NTUsImlhdCI6MTY4ODAzNjM1NSwiaXNzIjoicHJvYmxlbV9zZXJ2aWNlIiwianRpIjoiY2JhNjU2MDYtNTAxMi00OWY2LTgzZmYtOTQ4YjIzYmYxYzE5IiwibmJmIjoxNjg4MDM2MzU0LCJzdWIiOiIyIiwidHlwIjoiYWNjZXNzIn0.ac7GiAb-cerLQCq8QBkxENEiMzgAiQAemeQblnfAN-hfiUg3afSp7lUo-Bmdotp2lEiUKPdp9qczBGGxMoXVOw"

      headers = [Authorization: "Bearer #{token}", "Content-Type": "application/json"]

      HTTPoison.post!("#{@devUrl}/api/sector/generate", Jason.encode!(%{
        "sector" => sector,
      }), headers,
        timeout: 50_000,
        recv_timeout: 50_000
      )
    end)


  end
end

Seeder.execute()
