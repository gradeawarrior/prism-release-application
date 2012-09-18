require "net/http"

class PerryController < ApplicationController
  
  def gate
    if (params["path"] == nil)
      params["path"] = ""
      listGates()
    elsif (params["method"] == "promote")
      promoteRelease(params["path"], params["release"])
    else
      gateInfo(params["path"])
    end
  end
  
  def release
  end
  
  def listGates
    url = URI.parse('http://m0008001.ppops.net/inv_api/v1/service_instance?subtype=gate&type=environment')
    req = Net::HTTP::Get.new(url.path + '?subtype=gate&type=environment')
    req.basic_auth("readonly", "readonly")
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    @result = JSON.parse(res.body)
  end
  
  def gateInfo(current_gate)
    url = URI.parse("http://m0030773.lab.ppops.net:8889/v1/env/#{current_gate}/gateinfo?pretty")
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    @result = JSON.parse(res.body)
    
    # Jira
    #curl -Hcontent-type:application/json --data '{"jql":"cf[10000] = \"share\" and status = \"submitted\"", "fields":["id"]}' 'http://jgmyers:admin1!@jgmyers-vm5.eng.proofpoint.com:8080/rest/api/2/search'
    url = URI.parse("http://jgmyers:admin1!@jgmyers-vm5.eng.proofpoint.com:8080/rest/api/2/search")
    request_obj = {
      "jql" => "cf[10000] = \"#{current_gate}\" and status = \"released\"",
      "fields" => ["id"]
      }
    
    http = Net::HTTP.new(url.host, url.port)
    req = Net::HTTP::Post.new(url.path)
    req.body = request_obj.to_json
    req.content_type = 'application/json'
    req.basic_auth("jgmyers", "admin1!")
    res = http.request(req)
    if (res.code == 200)
      @jira_search = @JSON.parse(res.body)
      
      @result["accept"] = []
      @result[accept] = @jira_search["issues"]
      for a_release in @jira_search["issues"]
        @result["accept"] << a_release["key"]
      end
    end
    
  end
  
  def promoteRelease(current_gate, current_release)
    ## Environment Promote
    url = URI.parse("http://m0030773.lab.ppops.net:8889/v1/env/#{current_gate}/promote")
    path = "/v1/env/#{current_gate}/promote"
    request_obj = {"release"=>"#{current_release}"}
    http = Net::HTTP.new(url.host, url.port)
    res = http.request_put(path, request_obj)
  end
end
