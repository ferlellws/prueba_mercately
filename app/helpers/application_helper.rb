module ApplicationHelper
  def format_currency(amount)
    number_to_currency(amount, unit: "$", separator: ",", delimiter: ".", format: "%u%n")
  end
end
