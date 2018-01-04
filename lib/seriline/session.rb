module Seriline
  class Session < Struct.new(:success, :session_key, :error_message, :valid_to)
  end
end
