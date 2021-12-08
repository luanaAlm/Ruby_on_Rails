require 'rest-client'
require 'json'
require 'terminal-table'


days_to_show = ARGV[0] ? ARGV[0].split("=")[1].to_i : 7
end_date = Date.today.strftime("%Y-%m-%d") 
start_date = (Date.today - days_to_show).strftime("%Y-%m-%d")

#variável com a url da api do coindesk
url = 'https://api.coindesk.com/v1/bpi/historical/close.json'
	
#variável com os parâmetros
params = "?start=#{start_date}&end=#{end_date}"

#chamada para a API
response = RestClient.get "#{url}#{params}", {
    content_type: :json,  
    accept: :json 
}

puts response.body

#extrair do json retornado o histórico do bitcoin para a data
bpi = JSON.parse(response.body)["bpi"]

#comparar os preços do bitcoin
bpi_keys = bpi.keys

#matriz com data do registro
table_data = bpi.map.with_index do |(data, value), i|
    [
      Date.parse(data).strftime("%d/%m/%y"), 
      "$#{value.to_f}", 
      (i > 0 ? (bpi[bpi_keys[i]] > bpi[bpi_keys[i - 1]] ? "🡅" : "🡇") : "")
    ]
end
#mostrar a tabela
table = Terminal::Table.new :headings => ['Data', 'Valor do Bitcoin', '₿'], :rows => table_data

#exibir
puts table