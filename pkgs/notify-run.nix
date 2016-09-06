{ format-duration, push-notify, ruby, writeScriptBin }:
writeScriptBin "notify-run" ''
  #! ${ruby}/bin/ruby

  start_time = Time.now
  title = system(*ARGV) ? 'Success' : 'Failure'
  end_time = Time.now

  seconds = end_time - start_time

  if seconds > 5
    millis = (seconds * 1000).to_i
    elapsed = `${format-duration}/bin/format-duration #{millis}`
    title += " after #{elapsed}"

    system('${push-notify}/bin/push-notify', title, ARGV.join(' '))
  end
''
