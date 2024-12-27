require "nokogiri"

module IconsHelper

  def heroicon(name, style: :mini, **options)
    file = read_file(Rails.root.join("app/assets/icons/heroicons", style.to_s, "#{name}.svg"))
    return "" if file.nil?
    doc = Nokogiri::XML(file)
    svg = doc.root
    svg[:class] = options[:class].presence || "w-5 h-5"
    svg[:style] = options[:svg_style].presence
    ActiveSupport::SafeBuffer.new(svg.to_s)
  end
  
  private
  
    def read_file(path)
      return nil unless File.exist?(path)
      File.read(path)
    end

end

