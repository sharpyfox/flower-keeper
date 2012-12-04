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
		blue = (aHumidity % 50) * 255 / 100
		if aHumidity > 50
			green = (aHumidity - 50) * 255 / 100
			red = 0
		else
			green = 0
			red = (50 - aHumidity) * 255 / 100
		end

		return  "##{sprintf("%02X", red)}#{sprintf("%02X", green)}#{sprintf("%02X", blue)}"
	end
end
