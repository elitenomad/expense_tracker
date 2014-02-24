json.array!(@portions) do |portion|
  json.extract! portion, :id, :amount, :expenses_id, :payee_id
  json.url portion_url(portion, format: :json)
end
