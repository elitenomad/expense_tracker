json.array!(@expenses) do |expense|
  json.extract! expense, :id, :description, :amount, :group_id, :user_id
  json.url expense_url(expense, format: :json)
end
