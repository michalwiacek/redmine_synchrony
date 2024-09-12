require "redmine"

# require File.expand_path("lib/synchrony", __dir__)

Redmine::Plugin.register :redmine_synchrony do
  name "Redmine Synchrony plugin"
  author "Southbridge"
  description "Plugin makes copies of issues and journals from another redmine instance via API."
  version "0.0.5"
  url "https://github.com/southbridgeio/redmine_synchrony"
  author_url "https://southbridge.io"
  settings default: { "empty" => true }, partial: "settings/synchrony_settings"
end

if Rails.version > "6.0" && Rails.autoloaders.zeitwerk_enabled?
  Rails.application.config.after_initialize do
    Issue.include Synchrony unless Issue.included_modules.include? Synchrony
  end
else
  (Rails.version > "5" ? ActiveSupport::Reloader : ActionDispatch::Callbacks).to_prepare do
    require_dependency "issue"
    Issue.include Synchrony unless Issue.included_modules.include? Synchrony
  end
end
