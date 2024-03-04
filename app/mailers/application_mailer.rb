# frozen_string_literal: true

# Base class for mailer in rails
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
