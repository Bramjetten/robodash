module ApplicationHelper

  def current_wallpaper
    wallpapers = (1..5).to_a
    wallpapers.find{_1 == cookies[:wallpaper].to_i} || 3
  end

  def github_url
    "https://github.com/bramjetten/robodash"
  end

  def robodash_gem_url
    "https://github.com/Bramjetten/robodash-gem"
  end

end
