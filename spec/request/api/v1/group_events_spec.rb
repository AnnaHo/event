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

    it 'create an event successfully with calculating by duration date and empty end_date' do
      start_date = DateTime.now
      post '/v1/group_events', {group_event: {name: "a published event", 
                                              location: "Taipei", 
                                              start_date: start_date, 
                                              end_date: "",
                                              duration: "2", 
                                              description: "RailsPacific 2016", 
                                              status: "published"}}
      group_event = GroupEvent.last
      expect(response_json).to eq(JSON.parse(group_event.to_json))
    end

    it 'create an event successfully with calculating by duration date and empty start_date' do
      end_date = DateTime.now
      post '/v1/group_events', {group_event: {name: "a published event", 
                                              location: "Taipei", 
                                              start_date: "", 
                                              end_date: end_date,
                                              duration: "2", 
                                              description: "RailsPacific 2016", 
                                              status: "published"}}
      group_event = GroupEvent.last
      expect(response_json).to eq(JSON.parse(group_event.to_json))
    end

    it 'create an event successfully with calculating by duration date and empty start_date and end_date' do
      post '/v1/group_events', {group_event: {name: "a published event", 
                                              location: "Taipei", 
                                              start_date: "", 
                                              end_date: "",
                                              duration: "2", 
                                              description: "RailsPacific 2016", 
                                              status: "published"}}
      group_event = GroupEvent.last
      expect(response_json).to eq(JSON.parse(group_event.to_json))
    end
  end
end

describe 'PUT /v1/group_events/:id', type: :request do
  before do
    @group_event = GroupEvent.create(name: "rails meetup", status: "draft")
  end

  it 'update an group event successfully with valid params' do
    put "/v1/group_events/#{@group_event.id}", {group_event: {location: "tapei"}}
    @group_event.reload
    expect(response_json).to eq(JSON.parse(@group_event.to_json)) 
  end

  it 'update an group event failed with invalid params' do
    put "/v1/group_events/#{@group_event.id}", {group_event: {status: "published"}}
    expect(response).to have_http_status 422
  end
end

describe 'DELETE /v1/group_events/:id', type: :request do
  it 'soft delete group event' do
    group_event = GroupEvent.create(name: "an event", status: "draft")

    delete "/v1/group_events/#{group_event.id}"
    expect(response_json["message"]).to eq "group event are removed"
    group_event.reload
    expect(group_event.active).to be false 
  end

  it 'return error while event id are invalid' do
    delete "/v1/group_events/id"
    expect(response_json["message"]).to eq "group event not found"
    expect(response).to have_http_status 404
  end
end

def response_json
  JSON.parse(response.body)
end