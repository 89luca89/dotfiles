if string.match(get_window_type(), "WINDOW_TYPE_NORMAL") then
  if (string.find(get_application_name(),"MPV")==nil) then
    if (string.find(get_application_name(),"alculator")==nil) then
      center()
      maximize();
    end
  end
  focus();
end
