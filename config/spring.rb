Dir.glob('config/settings*').each do |settings|
  Spring.watch settings
end
