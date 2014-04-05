class ConversationsController < ApplicationController
	before_action :signed_in_user, only: [:new, :create, :reply, :trash, :untrash, :delete]
	helper_method :mailbox, :conversation

	def new
		@recipient_id = params[:recipient_id]
	end

	def create
		@recipient_id = params[:conversation][:recipient_id]
		recipient = User.find(@recipient_id)

		conversation = current_user.
			send_message(recipient, *conversation_params(:body, :subject)).conversation

		redirect_to conversation
	end

	def reply
		current_user.reply_to_conversation(conversation, *message_params(:body, :subject))
		redirect_to conversation
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
