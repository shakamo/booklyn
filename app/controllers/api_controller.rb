class ApiController < ApplicationController
  def recent
    render :json => Episode.new.get_recent
  end
  def content
    render :json => Content.new.get_list_by_id(params[:id])
  end
  def history
    render :json => Episode.new.get_history
  end
end
