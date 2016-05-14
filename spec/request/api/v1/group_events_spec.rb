require 'rails_helper'

describe 'GET /v1/group_events', type: :request do

  before do
    @event = GroupEvent.create(name: "an event", status: "draft")
  end

  it 'get all group_events' do
    get '/v1/group_events'
    result = JSON.parse(response.body)
    expect(result.size).to be 1
  end
end