# frozen_string_literal: true

class File
  class << self
    alias exists? exist?
  end
end
