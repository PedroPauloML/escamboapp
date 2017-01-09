class AdminMailerPreview < ActionMailer::Preview

  def update_email
    AdminMailer.update_email(Admin.first, Admin.last)
  end

  def send_message
    AdminMailer.update_email(Admin.first.email, Admin.last.email, "Subject Text", "Message")
  end
end