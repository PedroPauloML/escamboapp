class Backoffice::SendMailController < ApplicationController

  def edit
    @admin = Admin.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    begin
      AdminMailer.send_message(current_admin,
                               params[:'recipient-text'],
                               params[:'subject-text'],
                               params[:'message-text']).deliver_now
      @notify_message = "E-mail enviado com sucesso!"
      @notify_kind = "success"
    rescue
      @notify_message = "Erro no envio do e-mail"
      @notify_kind = "error"
    end
    respond_to do |format|
      format.js
    end
  end
end
