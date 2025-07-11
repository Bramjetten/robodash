module GlassUIHelper

  def glass_well
    content_tag(:div, class: "bg-gradient-to-br from-zinc-100/40 from-10% via-30% via-zinc-500/20 to-zinc-500/30 backdrop-blur-sm rounded-[14px] p-[1.5px] shadow-lg shadow-black/30 relative overflow-hidden") do
      content_tag(:div, class: "bg-zinc-900/50 rounded-[13px] px-3 py-2") do
        yield
      end
    end
  end

  def glass_link_classes(style = "default")
    classes = %w[flex items-center backdrop-blur-sm rounded-full text-base p-[1.5px] cursor-pointer]

    if style == "primary"
      classes.concat %w[
        bg-gradient-to-br from-cyan-200 from-10% via-30% via-cyan-300/90 to-cyan-300/80
        hover:from-cyan-100 hover:via-cyan-300/90 hover:to-cyan-300/90
        shadow-lg shadow-black/60
        drop-shadow-[0_1.5px_0px_theme(colors.cyan.700)]
      ]
    elsif style == "danger"
      classes.concat %w[
        bg-gradient-to-br from-red-300 from-10% via-30% via-red-400/90 to-red-400/80
        shadow-lg shadow-black/60
        drop-shadow-[0_1.5px_0px_theme(colors.red.700)]
      ]
    else
      classes.concat %w[
        bg-gradient-to-br from-zinc-100/60 from-10% via-30% via-zinc-200/30 to-zinc-700/30
        hover:from-zinc-100/70 hover:via-zinc-200/30 hover:to-zinc-700/30
        shadow-lg shadow-black/40
      ]
    end

    classes.join(" ")
  end

  def glass_inner_container_classes(style = "default")
    classes = %w[flex items-center rounded-full text-white font-medium px-4 h-10]

    if style == "primary"
      classes.concat %w[
        bg-gradient-to-b from-cyan-500 to-cyan-600
        hover:to-cyan-700/90
      ]
    elsif style == "danger"
      classes.concat %w[bg-gradient-to-b from-red-600 to-red-700]
    else
      classes.concat %w[
        bg-zinc-800/50
        hover:bg-zinc-800/70
      ]
    end

    classes.join(" ")
  end

  def glass_button_tag(content_or_options = nil, options = nil, &block)
    if content_or_options.is_a? Hash
      options = content_or_options
    else
      options ||= {}
    end

    options = { "name" => "button", "type" => "submit" }.merge!(options.stringify_keys)

    # Set glass style
    glass_style = options.dig("glass_style").to_s

    # Primary style
    if glass_style == "primary"
      container_classes = "shadow-xl shadow-cyan-500/30 rounded-full" 
      inner_shadow = "box-shadow: inset 0 0 10px rgba(255, 255, 255, .4)"
    elsif glass_style == "danger"
      container_classes = "shadow-xl shadow-red-500/30 rounded-full" 
      inner_shadow = "box-shadow: inset 0 0 10px rgba(255, 255, 255, .4)"
    end

    content_tag(:div, class: container_classes) do
      content_tag(:button, options.merge(class: glass_link_classes(glass_style))) do
        content_tag(:div, class: glass_inner_container_classes(glass_style), style: inner_shadow) do
          block_given? ? yield : (content_or_options || "Button")
        end
      end
    end
  end

  def glass_link_to(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options ||= {}

    html_options = convert_options_to_data_attributes(options, html_options)

    url = url_target(name, options)
    html_options["href"] ||= url

    # Set glass style
    glass_style = html_options.dig("glass_style").to_s

    # Primary style
    if glass_style == "primary"
      container_classes = "shadow-xl shadow-cyan-500/30 rounded-full" 
      inner_shadow = "box-shadow: inset 0 0 10px rgba(255, 255, 255, .4)"
    elsif glass_style == "danger"
      container_classes = "shadow-xl shadow-red-500/30 rounded-full" 
      inner_shadow = "box-shadow: inset 0 0 10px rgba(255, 255, 255, .4)"
    end

    content_tag(:div, class: container_classes) do
      content_tag("a", url, html_options.merge(class: glass_link_classes(glass_style))) do
        content_tag(:div, class: glass_inner_container_classes(glass_style), style: inner_shadow) do
          block_given? ? yield : name
        end
      end
    end
  end

end
