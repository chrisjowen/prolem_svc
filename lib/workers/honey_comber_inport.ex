defmodule Totem.Workers.HoneyComberImport do
  use Que.Worker

  # <select name="event_category" id="hc-event-category" required="required"><option value="0">All Categories</option> <option value="25104">Arts and Culture</option>
  # <option value="91170">Christmas</option>
  # <option value="25254">Editor's Picks</option>
  # <option value="25101">Food and Drinks</option>
  # <option value="25103">Kids</option>
  # <option value="25109">Music and Nightlife</option>
  # <option value="25106">Shopping</option>
  # <option value="25105">Sports and Fitness</option>
  # <option value="25110">Workshops</option>
  # </select>

  @base_url "https://thehoneycombers.com/singapore/wp-admin/admin-ajax.php?action=event_ajax_filter_search&event_filter=singapore-event-calendar"

  def perform(page: page, category: category) do
    args = "&event_category=#{category}&page=#{page}"
    response = HTTPoison.get!("#{@base_url}#{args}")

    items = response.body
    |> Jason.decode!()
    # |> Enum.each(&load_event/1)


    load_event(List.first(items))
  end

  defp load_event(event) do
    response = HTTPoison.get!(event["permalink"])

    {:ok, document} = Floki.parse_document(response.body)

    document
    |> Floki.find("p.headline")
    |> Floki.raw_html
    |> IO.inspect

    File.write!("./sample.html", response.body)
  end
end
