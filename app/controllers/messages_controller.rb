class MessagesController < ApplicationController
  def index
    @messages = Message.all.order(created_at: :asc)
    @message = Message.new
  end

  def create
    if params[:question_id]
      @question = Question.find(params[:question_id])
      answer = answer_select(@question, params[:answer])
      # binding.pry
      Message.create!(content: answer)
      @message = Message.new(content: "<p>あなたの答えは<span class='text-success'><strong>#{answer}</strong></span>です。</p>", answer: params[:answer], question_id: @question.id, robo: true)
    else
      @message = Message.new(message_params)
    end

    if @message.save && @message.content == "quiz"
      Message.create!(content: 'クイズです！！',question_id: Question.pluck(:id).sample, robo: true)
      redirect_to root_path
    elsif @message.save && params[:message_id].present?
      Message.find(params[:message_id]).update!(finished: true)
      redirect_to root_path
    elsif @message.save
      redirect_to root_path
    else
      @messages = Message.all.order(created_at: :asc)
      render :index
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def answer_select(question, answer)
    if answer.to_i == 1
      question.a_1
    elsif answer.to_i == 2
      question.a_2
    elsif answer.to_i == 3
      question.a_3
    elsif answer.to_i == 4
      question.a_4
    end
  end
end
