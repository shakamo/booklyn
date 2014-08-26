class ApiController < ApplicationController
  def recent
    render :json => Episode.new.get_recent
  end
end
