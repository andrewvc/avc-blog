files = File.open "flist"
files.each_line do |fn|
  fn.chomp!
  f = File.open(fn)
  contents = f.read
  f.close
  contents =~ /^# (.*)/
  if $1
    contents.sub! '---', "\---\ntitle: #{$1}"
    contents.sub! /^# (.*)/, ''
    File.open fn, "w" do |f|
      f.write contents
    end
  end
end
