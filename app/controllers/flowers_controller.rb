class FlowersController < ApplicationController
	before_filter :take_feed, :only => [:index]

	# GET /flowers
	# GET /flowers.json
	def index
		@title = "Главная"
		@flowers = Flower.all

		@parsed_data = {}
		@flowers.each do |flower|
			points = take_data(flower.cosmId)
			@parsed_data[flower.cosmId] = get_points(points)
		end

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @flowers }
		end
	end

	# GET /flowers/1
	# GET /flowers/1.json
	def show
		@title = "Просмотр"
		@flower = Flower.find(params[:id])

		data = take_data(@flower.cosmId);

		@parsed_data = get_points(data)
		
		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @flower }
		end
	end

	# GET /flowers/new
	# GET /flowers/new.json
	def new
		@title = "Новый цветок"
		@flower = Flower.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @flower }
		end
	end

	# GET /flowers/1/edit
	def edit
		@title = "Редактирование цветка"
		@flower = Flower.find(params[:id])
	end

	# POST /flowers
	# POST /flowers.json
	def create
		@flower = Flower.new(params[:flower])

		respond_to do |format|
			if @flower.save
				format.html { redirect_to @flower, notice: 'flower was successfully created.' }
				format.json { render json: @flower, status: :created, location: @flower }
			else
				format.html { render action: "new" }
				format.json { render json: @flower.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /flowers/1
	# PUT /flowers/1.json
	def update
		@flower = Flower.find(params[:id])

		respond_to do |format|
			if @flower.update_attributes(params[:flower])
				format.html { redirect_to @flower, notice: 'flower was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @flower.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /flowers/1
	# DELETE /flowers/1.json
	def destroy
		@flower = Flower.find(params[:id])
		@flower.destroy

		respond_to do |format|
			format.html { redirect_to flowers_url }
			format.json { head :no_content }
		end
	end

	private
		def take_feed
    		response = Cosm::Client.get('/v2/feeds/89489.json', :headers => {"X-ApiKey" => COSM_API_KEY})
    		@feed = Feed.new(response.body)
    	end

    	def take_data(feed_id)
    		responce = Cosm::Client.get("/v2/feeds/89489/datastreams/#{feed_id}?start=#{5.days.ago.strftime('%Y-%m-%dT%H:%M:%S')}&end=#{0.seconds.ago.strftime('%Y-%m-%dT%H:%M:%S')}&interval=300&limit=1000", :headers => {"X-ApiKey" => COSM_API_KEY})
    		@datastream = Cosm::Datastream.new(responce)			
    	end

    	def get_points(data)
    		points = data.datapoints.map{|x| [(DateTime.iso8601(x.at).in_time_zone('Moscow')).strftime('%s').to_i * 1000, x.value.to_f()] }
			points << [(DateTime.now.in_time_zone('Moscow')).strftime('%s').to_i * 1000, data.current_value.to_f()]

			points
    	end
end