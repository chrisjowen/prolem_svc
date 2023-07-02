defmodule ProblemService.Clients.Experts.ExpertFinderProfileExtractor do

  def extract(doc) do
    [name, institution] = parse_name_and_institution(doc)


    details = Floki.find(doc, "#generalDetails .spacify")
    |> Enum.take(2)
    |> Enum.map(fn element ->
      Floki.text(element)
    end)
    |> Enum.join((" | "))


    %{
      name: name,
      details: details,
      institution: String.trim(institution),
      categories: parse_categories(doc),
      email: parse_email(doc),
      image: Floki.find(doc, "#profilephoto") |> Floki.attribute("src") |> List.first(),
      bio: parse_bio(doc)
    }
  end

  defp parse_categories(doc) do
    doc
    |> Floki.find("#omnicontainer .singleCard .cardPadder a")
    |> Enum.filter(fn element ->
      [link | _] = Floki.attribute(element, "href")
      String.contains?(link, "search-experts")
    end)
    |> Enum.map(fn a ->
      Floki.text(a) |> String.trim()
    end)
  end

  defp parse_name_and_institution(doc) do
    doc
    |> Floki.find("#nameSection h1.underlined")
    |> Enum.map(fn a -> Floki.text(a) |> String.trim() end)
    |> List.first()
    |> String.split(",")
  end

  defp parse_email(doc) do
    doc
    |> Floki.find("#email_address_1")
    |> Enum.map(&Floki.text/1)
    |> Enum.join("")
    |> String.trim()
  end


  defp parse_bio(doc) do
    doc
    |> Floki.find("#maxbio .cardPadder")
    |> Floki.text()
    |> String.replace("Click to Shrink <<", "")
  end



end
