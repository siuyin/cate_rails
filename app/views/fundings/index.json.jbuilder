json.array!(@fundings) do |funding|
  json.extract! funding, :id, :title, :content, :photo, :amtTarget, :amtCurrent
  json.url funding_url(funding, format: :json)
end
