class GraphController < ApplicationController
  
  def environment
    @list = Array.new
    @list.push(1)
    @list.push(2)
    @list.push(3)
    @list.push({"Bob"=>"Hope", "User"=>"Name"})
    
    respond_to do |format|
      format.json
    end
  end
end
