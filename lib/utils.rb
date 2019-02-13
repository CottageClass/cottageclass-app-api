require 'pp'

module Utils
  def log(obj)
    s = "[#{self.class}] #{obj}"
    if obj.respond_to?(:backtrace)
      Rails.logger.error "#{s}\n#{obj.backtrace.join("\n")}"
    else
      Rails.logger.debug s
    end

    if Rails.env.development? || Rails.env.test?
      # rubocop:disable Rails/Output
      puts "[#{self.class}]"
      puts '------------------'
      pp obj
      puts '------------------'
      # rubocop:enable Rails/Output
    end
  end

  def log_errors(obj)
    log obj.errors.full_messages if obj.try(:errors).present?
  end

  def dump(obj, name)
    File.open(Rails.root.join('tmp', name), 'w') do |f|
      if obj.is_a?(String)
        f.write obj
      else
        PP.pp obj, f
      end
    end
  end

  module_function :log, :log_errors, :dump
end
