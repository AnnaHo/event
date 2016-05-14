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
end

def response_json
  JSON.parse(response.body)
end