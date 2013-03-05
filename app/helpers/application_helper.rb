module ApplicationHelper
  
  
  def ajaxReload(url)
    "<script> 
      setAjaxReload('#{url}');
    </script>".html_safe
  end
  def strip_rails_root(dir)
    ret = dir.gsub(Rails.root.to_s, "")
    ret = ret[1 .. -1] if ret =~ Regexp.new("^/")
    ret
  end

  def fullpath_to_asset_inside_build(asset)
    "#{request.protocol}#{request.host_with_port}/#{strip_rails_root(asset)}"
  end

  def strip_shell_colorization(text)
    text.gsub(/\e\[[^m]+m/, '')
  end

  def build_duration(build)
    seconds = (build.finished_at - build.started_at).to_i
    minutes = seconds / 60
    seconds = seconds - minutes * 60
    if minutes == 0
      "%ds" % [seconds]
    else
      "%dm %ds" % [minutes, seconds]
    end
  end

  def format_stability(stability)
    return "not yet built" if stability.nil?
    case stability
    when -1
      "not enough data"
    when 0
      "None of the last five builds succeeded"
    when 1
      "One of the last five builds succeeded"
    when 2
      "On the right path. Two of the last five builds succeeded"
    when 3
      "Getting there. Three of the last five builds succeeded"
    when 4
      "Looking good. Four of the last five builds succeeded"
    when 5
      "Great! All the last five builds succeeded"
    end
  end

  def formatted_status(status)
    case status
    when BuildPart::STATUS_OK
      "works"
    when BuildPart::STATUS_FAILED
      "failed"
    when BuildPart::STATUS_IN_QUEUE
      "in queue"
    when BuildPart::STATUS_PROGRESS
      "in progress"
    end
  end

  def status_css_class(status)
    case status
    when BuildPart::STATUS_OK
      "success"
    when BuildPart::STATUS_FAILED
      "important"
    when BuildPart::STATUS_IN_QUEUE
      "notice"
    when BuildPart::STATUS_PROGRESS
      "warning"
    end
  end

  def is_build_failed_due_to_timeout(build)
    unless build.parts.first.nil?
      build.parts.each do |part|
        part.output.each do |o|
          return true if o.exit_code == 999
        end
      end
    end
    false
  end

end
