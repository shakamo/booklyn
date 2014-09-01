class ApiController < ApplicationController
  def recent
    render :json => Episode.new.get_recent
  end
  def week
    render :json => Episode.new.get_recent_by_week(params[:week])
  end
  def atoz
    render :json => Episode.new.get_recent_by_atoz(params[:atoz])
  end
  def content
    render :json => Content.new.get_list_by_id(params[:id])
  end
  def history
    render :json => Episode.new.get_history
  end
end
