# spec/app_spec.rb
require File.expand_path '../../spec_helper.rb', __FILE__
require 'pp'

describe "blocks route" do

  it "post should fail on empty network_view" do
    post "/api/v1/blocks", { "cidr": "10.0.0.0/8" }.to_json
    json = JSON.parse(last_response.body)
    expect(json).to eq({
      "network_view"=>["can't be blank"]
    })
  end

  it "post should fail on empty cidr" do
    post "/api/v1/blocks", { "network_view": "foobar" }.to_json
    json = JSON.parse(last_response.body)
    expect(json).to eq({
      "cidr"=>["is not valid (e.g. 10.0.0.0/24)"]
    })
  end

  it "post should create new block" do
    post "/api/v1/blocks", { "cidr": "10.0.0.0/8", "network_view": "test" }.to_json
    expect(last_response.status).to eq(201)

    block = Block.all().first()
    expect(block["cidr"]).to eq ("10.0.0.0/8")
    expect(block["network_view"]).to eq ("test")
    expect(block["start_address"]).to eq (167772160)
    expect(block["end_address"]).to eq (184549375)
  end

  it "get :id should retrieve a block" do
    params = {
      "cidr" => "10.0.0.0/8",
      "network_view" => "test",
      "start_address" => 167772160,
      "end_address" => 184549375,
    }
    block = Block.new(params)
    block.save
    
    get "/api/v1/blocks/" + block["id"]
    json = JSON.parse(last_response.body)
    json.delete("id") # dont compare ID
    expect(json).to eq(params)   
  end

  it "invalid get :id should return json error message" do
    get "/api/v1/blocks/123"
    json = JSON.parse(last_response.body)
    expect(json).to eq({"message" => "Block not found"})   
  end

  it "get should list blocks" do
    get "/api/v1/blocks"
    expect(last_response.status).to eq(200)
  end

end
