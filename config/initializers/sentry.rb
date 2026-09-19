# Production error tracking. Wire-compatible with both hosted
# Sentry and self-hostable GlitchTip — set SENTRY_DSN (or
# `bin/rails credentials:edit` -> sentry: dsn:) to the target's DSN. Left
# unconfigured, Sentry.init no-ops: nothing is sent anywhere.
dsn = ENV["SENTRY_DSN"].presence || Rails.application.credentials.dig(:sentry, :dsn)

Sentry.init do |config|
  config.dsn = dsn
  config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]
  config.enabled_environments = %w[production]
  config.traces_sample_rate = 0.1
  # sentry-rails 7 ships every SQL query and controller request as a Sentry
  # Log by default. Keep sending errors and traces only, as under 6.x.
  config.rails.structured_logging.enabled = false
end
