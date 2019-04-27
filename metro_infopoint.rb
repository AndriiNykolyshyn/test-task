require 'yaml'
require 'rspec'

class MetroInfopoint
  def initialize(path_to_timing_file:, path_to_lines_file:)
	@timing_data = YAML.load_file(path_to_timing_file)['timing']
	@station_line = YAML.load_file(path_to_lines_file)['stations']
	from_station ="donetska"
	to_station = "ukrainska"
	@datas = []
	@datae = []
	@time = []
	@price = []
	@way=[]
	@inf=500
	@used = []
	@dist = []

	@timing_data.each do |data|
	@datas.push "#{data["start"]}"
	@datae.push "#{data["end"]}"
	@time.push data["time"]
	@price.push data["price"]
	end
	
	@n = @time.size	
	@matrix = Array.new(@time.size).map!{Array.new(@time.size)}
	@matrix1 = Array.new(@price.size).map!{Array.new(@price.size)}
	#puts @datas
	#puts @datae
	#puts @time
	calculate(from_station: from_station, to_station: to_station)
    # initialization here
  end

  def calculate(from_station:, to_station:)
	for i in 0...@n	
		@used[i] = 0
		@dist[i] = @inf
		for j in 0...@n
			if @datas[i] == @datae[j] || @datae[i] == @datae[j] 	
				@matrix[i][j] = @time[j] 
			else     
				@matrix[i][j] = @inf
			end
			@matrix[@datae.index(to_station) + 1][@datae.index(to_station) + 1] = 0
		end
	end
	for i in 0...@n	
		@used[i] = 0
		@dist[i] = @inf
		for j in 0...@n
			if @datas[i] == @datae[j] || @datae[i] == @datae[j] 	
				@matrix1[i][j] = @price[j] 
			else     
				@matrix1[i][j] = @inf
			end
			@matrix1[@datae.index(to_station) + 1][@datae.index(to_station) + 1] = 0
		end
	end
    { price: calculate_price(from_station: from_station, to_station: to_station),
      time: calculate_time(from_station: from_station, to_station: to_station) }
  end

  def calculate_price(from_station:, to_station:)
	i=0
	z=0
	w=0
	start = @datas.index(from_station)
	endl = @datae.index(to_station)
	@rout = @matrix1[start][endl]
	@way.push from_station
	@used[start] = 1
	@dist[start] = 0
	while !@way.empty? do
		w = endl
		@way.pop
		for j in 0...@n do
			if @used[i] == 0 && @matrix1[w][j] < @rout 
			@dist[j] = @dist[w] + @matrix1[w][j]
				if j == endl && @dist[j] < @rout
					@rout =	 @dist[i]
					w = @dist[i]
				end
				@way.push @datas[j]
				@used[i] = 1
			end
		end	
	end
	if @rout == @inf
		puts "There is no way"	
	else
		puts @rout
		@way.each do |q|
		puts q
	end
    # your implementation here
	end
  end

  def calculate_time(from_station:, to_station:)
	i=0
	z=0
	w=0
	start = @datas.index(from_station)
	endl = @datae.index(to_station)
	@rout = @matrix[start][endl]
	@way.push from_station
	@used[start] = 1
	@dist[start] = 0
	while !@way.empty? do
		w = endl
		@way.pop
		for j in 0...@n do
			if @used[i] == 0 && @matrix[w][j] < @rout 
			@dist[j] = @dist[w] + @matrix[w][j]
				if j == endl && @dist[j] < @rout
					@rout =	 @dist[i]
					w = @dist[i]
				end
				@way.push @datas[j]
				@used[i] = 1
			end
		end	
	end
	if @rout == @inf
		puts "There is no way"	
	else
		puts @rout
		@way.each do |q|
		puts q
	end
	end
    # your implementation here
  end
end

MetroInfopoint.new path_to_timing_file: "./config/timing2.yml", path_to_lines_file: "./config/config.yml"

