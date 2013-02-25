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
      "abandon the project"
    when 1
      "start fixing asap"
    when 2
      "could be worse"
    when 3
      "not bad"
    when 4
      "looking good"
    when 5
      "great"
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
    if build.status == Build::STATUS_FAILED 
      unless build.parts.last.nil?
        if build.parts.last.output[0].exit_code == 999
          return true
        end
      end
    end
    false
  end

end
