module FlowersHelper
	LABEL_COLOR = 'black'
	PLOTS_OPACITY = 0.2

	def getHumidity(aFlower, aFeed)
		aFeed.datastreams.each do |stream|
			if aFlower.cosmId == stream.id
				return stream.current_value
			end
		end

		return nil
	end

	def humidityToColor(aHumidity)
		if aHumidity > 50
			red = 0
			green = ((aHumidity.to_f - 50.0) / 50.0 * 255.0).round
			blue = ((100 - aHumidity.to_f) / 50.0 * 255.0).round
		else
			red = ((50.0 - aHumidity.to_f) / 50.0 * 255.0).round
			green = 0
			blue = ((aHumidity.to_f) / 50.0 * 255.0).round
		end

		return  "##{sprintf("%02X", red)}#{sprintf("%02X", green)}#{sprintf("%02X", blue)}"
	end

	def create_chart
		@chart = LazyHighCharts::HighChart.new('graph') do |f|
  			f.options[:chart][:type] = 'spline'
  			f.options[:title][:text] = 'Увлажненность в течении последнего месяца'
  			
  			f.options[:xAxis][:type] = 'datetime'
  			
  			f.options[:yAxis][:text] = 'Увлажненность (%)'

  			build_yAxis(f.options[:yAxis]);

  			f.options[:plotOptions][:spline] = {}
  			f.options[:plotOptions][:spline][:lineWidth] = 2
  			f.options[:plotOptions][:spline][:states] = {}
  			f.options[:plotOptions][:spline][:states][:hover] = {}
  			f.options[:plotOptions][:spline][:states][:hover][:linewidth] = 3

  			f.options[:plotOptions][:spline][:marker] = {}
  			f.options[:plotOptions][:spline][:marker][:enabled] = false
			f.options[:plotOptions][:spline][:marker][:states] = {}
			f.options[:plotOptions][:spline][:marker][:states][:hover] = {}
			f.options[:plotOptions][:spline][:marker][:states][:hover][:enabled] = true
  			f.options[:plotOptions][:spline][:marker][:states][:hover][:symbol] = 'circle'
  			f.options[:plotOptions][:spline][:marker][:states][:hover][:radius] = 5
  			f.options[:plotOptions][:spline][:marker][:states][:hover][:lineWidth] = 1

			f.options[:navigation] = {}
			f.options[:navigation][:menuItemStyle] = {}
  			f.options[:navigation][:menuItemStyle][:fontSize] = '10px'
		end
	end

	def build_yAxis(axis)
		axis[:min]                = 0
		axis[:max]                = 100
		axis[:minorGridLineWidth] = 0
		axis[:gridLineWidth]      = 0
		axis[:alternateGridColor] = nil
		
		axis[:plotBands] ||= []
		add_plot_bands(axis[:plotBands])
	end

	def add_band(aBands, aFrom, aTo, aColor, alabelText)
		band ||= {}
		band[:from]  = aFrom
		band[:to]    = aTo
		band[:color] = aColor
		
		band[:label] ||= {}
		band[:label][:text]          = alabelText
		band[:label][:style]         = {}
		band[:label][:style][:color] = LABEL_COLOR

		aBands << band
	end

	def add_plot_bands (bands)
		add_band(bands, 0,  30,  "rgba(255, 0, 0, #{PLOTS_OPACITY})",  'Камень');
		add_band(bands, 30, 40,  "rgba(77, 0, 179, #{PLOTS_OPACITY})", 'Засох');
		add_band(bands, 40, 50,  "rgba(26, 0, 230, #{PLOTS_OPACITY})", 'Пора поливать');
		add_band(bands, 50, 70,  "rgba(0, 51, 204, #{PLOTS_OPACITY})", 'Подсыхает');
		add_band(bands, 70, 90,  "rgba(0, 204, 51, #{PLOTS_OPACITY})", 'Хорошо полит');
		add_band(bands, 90, 100, "rgba(0, 255, 0, #{PLOTS_OPACITY})",  'Как вода');
	end
end
