class ChristianMailer < ActionMailer::Base
  default(
    from: "Christian DeWolf <me@christiandewolf.com>",
    reply_to: "me@christiandewolf.com",
    content_type: "text/html"
  )
end
