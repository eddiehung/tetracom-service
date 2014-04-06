class ConversationsController < ApplicationController
	before_action :signed_in_user, only: [:new, :create, :reply, :trash, :untrash, :delete]
	before_filter :mailbox, :box
	helper_method :mailbox, :conversation

	def index
		if @box.eql? "inbox"
			@conversations = @mailbox.inbox.page(params[:page]).per(10)
		elsif @box.eql? "sentbox"
			@conversations = @mailbox.sentbox.page(params[:page]).per(10)
		else
			@conversations = @mailbox.trash.page(params[:page]).per(10)
		end
	end

	def new
		@recipient_id = params[:recipient_id]
	end

	def create
		@recipient_id = params[:conversation][:recipient_id]
		recipient = User.find(@recipient_id)

		conversation = current_user.
			send_message(recipient, *conversation_params(:body, :subject)).conversation

		redirect_to conversation_path(conversation.id)
	end

	def reply
		current_user.reply_to_conversation(conversation, *message_params(:body, :subject))
		redirect_to conversation_path(conversation.id)
	end

	def trash
		conversation.move_to_trash(current_user)
		redirect_to :conversations
	end

	def untrash
		conversation.untrash(current_user)
		redirect_to :conversations
	end

	def delete
		conversation.mark_as_deleted(current_user)
		redirect_to :conversations
	end

	private

	def mailbox
		@mailbox ||= current_user.mailbox
	end

	def box
		if params[:box].blank? or !["inbox","sentbox","trash"].include?params[:box]
			params[:box] = 'inbox'
		end
		@box = params[:box]
	end

	def conversation
		@conversation ||= mailbox.conversations.find(params[:id])
	end

	def conversation_params(*keys)
		fetch_params(:conversation, *keys)
	end

	def message_params(*keys)
		fetch_params(:message, *keys)
	end

	def fetch_params(key, *subkeys)
		params[key].instance_eval do
			case subkeys.size
			when 0 then self
			when 1 then self[subkeys.first]
			else subkeys.map{|k| self[k] }
			end
		end
	end

end
