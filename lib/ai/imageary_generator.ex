defmodule Ai.ImageryGenerator do
  alias Faker.Commerce
  alias Ai.PromptBuilder
  alias Ai.PromptExecutor

  def execute(content) do
    {:ok, prompt} =
      PromptBuilder.new()
      |> PromptBuilder.with_type(:json)
      |> PromptBuilder.with_goal(goal())
      |> PromptBuilder.with_hints(hints())
      |> PromptBuilder.with_examples(examples())
      |> PromptBuilder.with_format(format())
      |> PromptBuilder.with_action(action(content))
      |> PromptBuilder.build()

    prompt |> PromptExecutor.execute()
  end

  def goal() do
    """
    You are PainterAI, an AI that can generate image descriptions based on text.
    Your goal is to take some text and return imagery associated with the content as if you were going to paint a picture of it, the response should be in JSON format.
    """
  end

  def format() do
    """
    {
      "imagery": String,
    }
    """
  end

  def hints() do
    """
      Describe what imagery you would expect to be associated with the input. For example for artificial intelligence
    """
  end

  def examples() do
    """
      Prompt:
      ```
      {
        "content": "<h1>Artificial Intelligence (AI) Industry Report</h1><p>The Artificial Intelligence (AI) industry is revolutionizing the way businesses operate and people live their daily lives. AI is a branch of computer science that enables machines to simulate human intelligence and behaviors, such as perception, learning, reasoning, and decision-making.</p><h2>Current State</h2><p>The global AI market size was valued at USD 62.35 billion in 2020 and is expected to grow at a compound annual growth rate (CAGR) of 40.2% from 2021 to 2028. The major players in the industry include IBM, Google, Amazon, Microsoft, and NVIDIA. The competitive landscape is intense with many startups and venture capitalists investing heavily in the industry. The dominant trend is the development of innovative AI technologies, such as deep learning, natural language processing, and computer vision.</p><h2>Key Drivers and Challenges</h2><p>The main factor driving the growth of the AI industry is the increasing demand for automation, predictive analytics, and personalized customer experiences. The COVID-19 pandemic has accelerated the adoption of AI in healthcare, education, and e-commerce sectors. However, the industry faces several challenges, including ethical concerns, lack of technical talent, data privacy issues, and regulatory barriers.</p><h2>Target Customers or Clients</h2><p>The target market for the AI industry includes businesses of all sizes, government agencies, and consumers. The demographics, preferences, and behaviors of the target customers are diverse and rapidly evolving. The segments within the market that are more profitable or growing faster are healthcare, finance, and manufacturing sectors.</p><h2>Major Products or Services</h2><p>The major offerings of the AI industry include machine learning platforms, chatbots, robotic process automation (RPA) tools, cognitive computing systems, and AI chips. Innovative products and services in the industry include AI-powered autonomous vehicles, predictive maintenance software, and emotion recognition systems.</p><h2>Revenue Streams and Business Models</h2><p>The revenue streams of AI companies include software licenses, cloud-based services, consulting, and hardware sales. Many companies adopt recurring revenue and subscription-based business models to generate stable income. The major cost drivers in the industry are data acquisition, computing power, and talent acquisition.</p><h2>Growth Prospects</h2><p>The AI industry has immense growth potential due to the increasing demand for AI-based solutions, technologies, and products. The projected future trends and growth opportunities include the adoption of edge computing, quantum computing, and explainable AI. Disruptive technologies and business models on the horizon include AI-enabled smart cities, AI-powered drones, and decentralized AI networks. Key barriers to entry or exit that may impact growth include high entry costs, intellectual property rights, and market consolidation.</p><h2>External Factors</h2><p>The AI industry is sensitive to changes in regulations, privacy laws, and political events. The industry is also impacted by macroeconomic factors such as trade policies, exchange rates, and economic growth. Environmental and sustainability considerations are increasingly becoming important for AI companies to address, as the industry has a significant carbon footprint due to high energy consumption.</p><h2>Impact of Technology</h2><p>Technology is the cornerstone of the AI industry, and its advancements are continuously driving change. Some technological advancements driving change include the development of neuromorphic computing, Explainable AI (XAI) model, and federated learning. Digitalization and automation play an essential role in the industry, enabling AI systems to analyze vast amounts of data and automate routine tasks. Emerging technologies that may disrupt the sector include blockchain-based AI networks and human-level AI.</p><h2>Risks and Opportunities</h2><p>The major risks and challenges faced by AI companies include ethical concerns, biased algorithms, and data privacy issues. Underserved segments and untapped market opportunities in the AI industry include environmental monitoring, agricultural automation, and autonomous delivery. Potential partnerships or collaborations that can lead to growth include collaborations between AI companies and academic institutions, governments, and ecosystem partners.</p><h2>Long-Term Trends and Predictions</h2><p>The future of the AI industry is promising and likely to evolve rapidly over the next few years. Industry experts and analysts predict that AI systems will become increasingly integrated into everyday life, human-machine collaboration will become more common, and AI-based solutions will drive significant advancements in healthcare, climate change mitigation, and social good initiatives.</p>"
      }
      ```

      Response:

     ```
     {
      "imagery": "An image of a computer with a human brain, symbolizing the combination of human intelligence and machine learning. In the background, there are various objects and symbols representing the applications of AI, such as autonomous vehicles, chatbots, robotic process automation tools, and emotion recognition systems. The image also features various logos of major players in the industry, such as IBM, Google, Amazon, Microsoft, and NVIDIA. Additionally, the image includes a graph showing the growth of the global AI market over time and a chart showing the revenue streams and business models of the industry."
    }
      ```
    """
  end

  defp action(content) do
    """
      The text to generate imagery from is specified below in HTML within the tripple backticks
      ```
        #{content}
      ```
    """
  end
end
