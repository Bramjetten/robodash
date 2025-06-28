class WallpaperController < ApplicationController

  def create
    cookies[:wallpaper] = params[:wallpaper]
    redirect_back fallback_location: root_url
  end
  
end
