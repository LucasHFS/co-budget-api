class Result
  attr_reader :success, :data, :errors

  def initialize(success:, data: nil, errors: nil)
    @success = success
    @data = data
    @errors = errors
  end

  def self.success(data = nil)
    new(success: true, data:)
  end

  def self.failure(errors)
    new(success: false, errors:)
  end

  def success?
    success
  end

  def failure?
    !success
  end
end
