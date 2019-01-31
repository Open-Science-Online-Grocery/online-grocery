if Rails.env.development? || Rails.env.staging?
  Dkim::domain = 'howes-grocery.scimed-test.com'
elsif Rails.env.production?
  Dkim::domain = 'howesgrocery.com'
end
Dkim::signable_headers = Dkim::DefaultHeaders -
    %w{ Message-ID Resent-Message-ID Date Return-Path Bounces-To }
Dkim::selector = 'mail'
Dkim::private_key = open('howes_grocery.priv').read
