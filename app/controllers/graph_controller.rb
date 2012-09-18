require "net/http"

class GraphController < ApplicationController
  
  def environment
    @list = Array.new
    @list.push(1)
    @list.push(2)
    @list.push(3)
    @list.push("hello")
    @list.push({"Bob"=>"Hope", "User"=>"Name"})
    
    #url = URI.parse('http://m0030773.lab.ppops.net:8889/v1/env/staging/gateinfo')
    url = URI.parse('http://m0008001.ppops.net/inv_api/v1/service_instance')
    req = Net::HTTP::Get.new(url.path)
    req.basic_auth("readonly", "readonly")
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    @result = JSON.parse(res.body)
    
    respond_to do |format|
      format.json
    end
  end
end
