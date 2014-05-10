class VimEat < Sinatra::Base
	# Get today's random pick
	get '/today' do
		dateStr = `date "+%Y%m%d"`.chop!
		content_type :json
    	today = JSON.parse(read_or_create_today_random_pick)
    	JSON.pretty_generate(today)
	end
	
	# Update today's random pick, most likey a vote action.
	post '/today' do
		json_request = JSON.parse(request.body.read)
		index = json_request['index']
		voter = request.ip

		today = JSON.parse(read_or_create_today_random_pick)

		# If the voter still not voted on any restaurants
		result = 1
		if (voter_is_valid_today(voter, today))
			today['today'][index]['vote'] += 1
			today['today'][index]['voters'].push(voter)
			update_today_random_pick(today)
			result = 0
		end
		
		response = {'result' => result, 'voter' => voter }

		content_type :json
		json response
	end

	post '/today/blackbox' do
		# Usage: curl -d "date=20140317&id=ABCDEFGH" http://<host_address>/today/blackbox
		date = params[:date]
		id = params[:id]
		blackbox_pick(date, id)
	end

	post '/today/comments' do
		msg = JSON.parse(request.body.read)
		add_comment_on_today(msg)
		200
	end
end