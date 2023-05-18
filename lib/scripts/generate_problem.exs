problem = """

In logistics,  improving forecast accuracy and having a repeatable, reliable demand forecasting process. Accurate forecasts help minimize inventory, maximize production efficiency, streamline purchasing, optimize distribution, maximize customer service and ensure confidence in company projections.

However, developing accurate product forecasts at all stages of a product’s life cycle can be challenging

Supply chain forecasting and weather forecasts have more than one thing in common.

 Both make predictions based on past and present information, and both use hard data, and, at times, intuition, to varying degrees of accuracy. And in both cases, something that didn’t appear on the radar can leave you feeling caught out and unprepared—whether that’s without an umbrella or without the inventory needed to fill an order.

Understanding how to properly forecast your supply chain needs is critical to ensuring your ecommerce store’s success. Getting it right can lead to better supplier relationships, increased customer satisfaction, and more capital to grow and scale your business.


.
"""

sector_id = 12


Que.add(ProblemService.Workers.ProblemCurationWorker,
    %{sector_id: sector_id, problem: problem, user_id: 1, identifier: "SYSTEM"}
)
