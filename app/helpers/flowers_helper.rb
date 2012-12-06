module FlowersHelper
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
end
