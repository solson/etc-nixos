{ ruby, writeScriptBin }:
writeScriptBin "format-duration" ''
  #! ${ruby}/bin/ruby

  def format_duration(total_ms)
      total_s, ms = total_ms.divmod(1000)
      total_m, s = total_s.divmod(60)
      total_h, m = total_m.divmod(60)
      total_d, h = total_h.divmod(24)
      d = total_d

      ms_hundreds = (ms / 100.0).round

      if d > 0
          "#{d}d #{h}h #{m}m #{s}s"
      elsif h > 0
          "#{h}h #{m}m #{s}s"
      elsif m > 0
          "#{m}m #{s}s"
      elsif ms_hundreds > 0
          "#{s}.#{ms_hundreds}s"
      else
          "#{s}s"
      end
  end

  puts format_duration(ARGV[0].to_i)
''
