module OxiesHelper
  def days_matrix(date)
    first = date.beginning_of_month
    last  = date.end_of_month
    (first.beginning_of_week..last.end_of_week).to_a.in_groups_of(7)
  end
end
