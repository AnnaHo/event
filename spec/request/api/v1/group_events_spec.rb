require 'rails_helper'

describe 'GET /v1/group_events', type: :request do

  before do
    @event = GroupEvent.create(name: "an event", status: "draft")
  end

  it 'get all group_events' do
    get '/v1/group_events'
    expect(response_json.size).to be 1
  end
end

describe 'POST /v1/group_events', type: :request do
  it 'create an event with draft status' do
    post '/v1/group_events', {group_event: {name: "a new event", status: "draft"}}
    group_event = GroupEvent.last
    expect(response_json).to eq(JSON.parse(group_event.to_json))
  end

  context 'with published status' do
    it 'create an event failed with invalid params' do
      post '/v1/group_events', {group_event: {name: "a published event", 
                                              location: "Taipei", 
                                              status: "published"}}
      expect(response).to have_http_status 422
      expect(response_json["message"]).to eq "failed to create event"
    end

    it 'create an event successfully with vaild params' do
      start_date = DateTime.now
      end_date = start_date+30.days
      post '/v1/group_events', {group_event: {name: "a published event", 
                                              location: "Taipei", 
                                              start_date: start_date, 
                                              end_date: end_date, 
                                              description: "RailsPacific 2016", 
                                              status: "published"}}
      group_event = GroupEvent.last
      expect(response_json).to eq(JSON.parse(group_event.to_json))
    end
  end
end

def response_json
  JSON.parse(response.body)
end