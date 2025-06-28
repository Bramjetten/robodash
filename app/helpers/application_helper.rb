module ApplicationHelper

  def current_wallpaper
    wallpapers = (1..5).to_a
    wallpapers.find{_1 == cookies[:wallpaper].to_i} || 3
  end

end
