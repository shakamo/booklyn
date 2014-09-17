require "open3"

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
  def seo
    if params[:_escaped_fragment_] == ''
      path = request.host_with_port + request.fullpath
      path = path.gsub('?_escaped_fragment_=','')
      out, err, status = Open3.capture3('phantomjs /phantomjs-test.js ' + path)
      out.gsub!('<meta name="fragment" content="!">','')
      render :inline => out
    else
      render :file => 'index.html', :layout => false
    end
  end
end
