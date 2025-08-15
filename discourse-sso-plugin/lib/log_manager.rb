# discourse-sso-plugin/lib/log_manager.rb
module LogManager
  LOG_FILE = "#{Rails.root}/log/sso_plugin.log"

  def self.init(log_file: LOG_FILE)
    @logger = Logger.new(log_file, 'daily')
    @logger.formatter = proc do |severity, time, progname, msg|
      "#{time.iso8601} [#{severity}] #{msg}\n"
    end
  end

  def log(message, level = :info)
    levels = { info: Logger::INFO, error: Logger::ERROR }
    @logger.add(levels[level]) { message }
  end
end